class ListingsController < ApplicationController
  def index
    @q = Listing.active.ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?

    listings = @q.result(distinct: true)
    listings = listings.by_city(params[:city])         if params[:city].present?
    listings = listings.by_category(params[:category]) if params[:category].present?

    if params[:min_price].present?
      listings = listings.where("price_per_hour >= ?", params[:min_price].to_f)
    end
    if params[:max_price].present?
      listings = listings.where("price_per_hour <= ?", params[:max_price].to_f)
    end
    if params[:min_capacity].present?
      listings = listings.where("capacity >= ?", params[:min_capacity].to_i)
    end
    if params[:date].present?
      booked_ids = Booking.where(status: %w[confirmed pending])
                          .where("DATE(start_time) = ?", Date.parse(params[:date]))
                          .select(:listing_id)
      listings = listings.where.not(id: booked_ids)
    end

    @pagy, @listings = pagy(listings, limit: 12)
    @cities     = Listing::CITIES
    @categories = Listing::CATEGORIES
    @max_price_ceiling = Listing.active.maximum(:price_per_hour).to_i
  end

  def show
    @listing = Listing.active.find(params[:id])
    @reviews = @listing.reviews.includes(:user).order(created_at: :desc)
    @booking = Booking.new

    host_gateways       = @listing.user.gateway_configs.active.pluck(:gateway)
    @available_gateways = host_gateways & @listing.accepted_gateways_list
  end
end
