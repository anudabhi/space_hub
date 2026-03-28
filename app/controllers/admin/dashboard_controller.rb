class Admin::DashboardController < AdminApplicationController

  def index
    @users_count    = User.count
    @listings_count = Listing.count
    @bookings_count = Booking.count
    @revenue        = Booking.where(status: "completed").sum(:total_price)
    @recent_users   = User.order(created_at: :desc).limit(5)
    @recent_bookings = Booking.includes(:listing, :user).order(created_at: :desc).limit(10)
  end
end
