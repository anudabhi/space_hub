class Guest::BookingsController < GuestApplicationController
  before_action :set_booking, only: %i[show cancel]

  def index
    @upcoming = current_user.bookings.includes(:listing).upcoming.order(start_time: :asc)
    @past      = current_user.bookings.includes(:listing).past.order(start_time: :desc)
    @cancelled = current_user.bookings.includes(:listing).cancelled.order(updated_at: :desc)
  end

  def show
    authorize! :read, @booking
  end

  def cancel
    authorize! :cancel, @booking
    if @booking.status.in?(%w[pending confirmed])
      @booking.update!(status: "cancelled")
      redirect_to guest_bookings_path, notice: "Booking cancelled."
    else
      redirect_to guest_bookings_path, alert: "This booking cannot be cancelled."
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end
end
