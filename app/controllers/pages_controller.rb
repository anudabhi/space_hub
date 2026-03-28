class PagesController < ApplicationController
  def home
    @featured_listings = Listing.active.order(avg_rating: :desc).limit(6)
    @cities = Listing::CITIES
    @categories = Listing::CATEGORIES
  end

  def about; end
  def how_it_works; end
  def privacy; end
  def terms; end
  def become_host; end
end
