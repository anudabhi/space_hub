class Host::BookingsController < HostApplicationController
  before_action :set_booking, only: %i[show confirm complete]

  def index
    @bookings = Booking.joins(:listing)
                       .where(listings: { user_id: current_user.id })
                       .includes(:listing, :user)
                       .order(start_time: :desc)

    @bookings = @bookings.where(status: params[:status]) if params[:status].present? && params[:status] != "all"

    if params[:from].present?
      @bookings = @bookings.where("start_time >= ?", Date.parse(params[:from]).beginning_of_day)
    end

    if params[:to].present?
      @bookings = @bookings.where("start_time <= ?", Date.parse(params[:to]).end_of_day)
    end

    @status_counts = Booking.joins(:listing)
                            .where(listings: { user_id: current_user.id })
                            .group(:status)
                            .count
  end

  def show
    authorize! :read, @booking
  end

  def confirm
    authorize! :confirm, @booking
    @booking.update!(status: "confirmed")
    BookingNotificationService.new(@booking).on_confirmed
    redirect_to host_booking_path(@booking), notice: "Booking confirmed."
  end

  def complete
    authorize! :complete, @booking
    @booking.update!(status: "completed")
    BookingNotificationService.new(@booking).on_completed
    redirect_to host_booking_path(@booking), notice: "Booking marked as completed."
  end

  private

  def set_booking
    @booking = Booking.joins(:listing)
                      .where(listings: { user_id: current_user.id })
                      .find(params[:id])
  end
end
