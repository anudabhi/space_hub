class BookingNotificationService
  def initialize(booking, routes: Rails.application.routes.url_helpers)
    @booking = booking
    @routes  = routes
  end

  def on_created
    BookingMailer.booking_created(@booking).deliver_later
    BookingMailer.host_new_booking(@booking).deliver_later
    Notification.notify(
      user:    @booking.listing.user,
      message: "#{@booking.user.display_name} requested to book #{@booking.listing.title}",
      link:    @routes.host_booking_path(@booking),
      kind:    "booking_created"
    )
  end

  def on_confirmed
    BookingMailer.booking_confirmed(@booking).deliver_later
    Notification.notify(
      user:    @booking.user,
      message: "Your booking at #{@booking.listing.title} has been confirmed!",
      link:    @routes.guest_booking_path(@booking),
      kind:    "booking_confirmed"
    )
  end

  def on_completed
    Notification.notify(
      user:    @booking.user,
      message: "Your booking at #{@booking.listing.title} is complete. Leave a review!",
      link:    @routes.guest_booking_path(@booking),
      kind:    "booking_completed"
    )
  end
end
