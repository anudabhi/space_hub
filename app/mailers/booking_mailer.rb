class BookingMailer < ApplicationMailer
  def booking_created(booking)
    @booking = booking
    @guest   = booking.user
    @listing = booking.listing
    @host    = @listing.user
    mail(to: @guest.email, subject: "Booking Confirmed — #{@listing.title}")
  end

  def booking_confirmed(booking)
    @booking = booking
    @guest   = booking.user
    @listing = booking.listing
    mail(to: @guest.email, subject: "Your booking at #{@listing.title} is confirmed!")
  end

  def host_new_booking(booking)
    @booking = booking
    @guest   = booking.user
    @listing = booking.listing
    @host    = @listing.user
    mail(to: @host.email, subject: "New booking request for #{@listing.title}")
  end
end
