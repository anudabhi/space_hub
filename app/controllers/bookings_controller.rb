class BookingsController < UserApplicationController
  before_action :set_listing

  def new
    @booking = Booking.new
    @available_gateways = available_gateways
    authorize! :create, @booking
  end

  def create
    @booking = @listing.bookings.build(booking_params)
    @booking.user = current_user
    authorize! :create, @booking
    @available_gateways = available_gateways

    # If host has gateways configured, validate the selected one
    if @available_gateways.any? && !@available_gateways.include?(@booking.payment_gateway)
      @booking.errors.add(:payment_gateway, "is not accepted by this listing")
      return render :new, status: :unprocessable_entity
    end

    # No gateways configured — booking awaits manual host confirmation
    @booking.payment_gateway = nil if @available_gateways.empty?
    @booking.status = "pending"
    hours = (@booking.end_time - @booking.start_time) / 1.hour
    @booking.hours = hours.round(1)
    @booking.total_price = (hours * @listing.price_per_hour).round(2)

    if @booking.save
      BookingNotificationService.new(@booking).on_created
      notice = @available_gateways.any? ? "Booking created! Complete payment below." \
                                        : "Booking requested! The host will confirm shortly."
      redirect_to guest_booking_path(@booking), notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_listing
    @listing = Listing.active.find(params[:listing_id])
  end

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :payment_gateway)
  end

  def available_gateways
    host_gateways = @listing.user.gateway_configs.active.pluck(:gateway)
    host_gateways & @listing.accepted_gateways_list
  end
end
