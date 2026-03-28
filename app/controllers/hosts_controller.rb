class HostsController < ApplicationController
  def show
    @host     = User.where(role: "host", host_approved: true).find(params[:id])
    @listings = @host.listings.active.order("avg_rating DESC NULLS LAST")
    @reviews  = Review.joins(:listing)
                      .where(listings: { user_id: @host.id })
                      .includes(:user, :listing)
                      .order(created_at: :desc)
                      .limit(6)
    @total_reviews = Review.joins(:listing).where(listings: { user_id: @host.id }).count
    @avg_rating    = Review.joins(:listing).where(listings: { user_id: @host.id })
                           .average(:rating)&.to_f&.round(1)
  end
end
