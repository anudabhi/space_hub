class Admin::BookingsController < AdminApplicationController
  def index
    @pagy, @bookings = pagy(Booking.includes(:listing, :user).order(created_at: :desc))
  end

  def show
    @booking = Booking.includes(:listing, :user, :payment, :review).find(params[:id])
  end
end
