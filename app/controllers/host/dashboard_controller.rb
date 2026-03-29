class Host::DashboardController < HostApplicationController
  def index
    @listings = current_user.listings.order(created_at: :desc)

    host_bookings = Booking.joins(:listing).where(listings: { user_id: current_user.id })

    @recent_bookings = host_bookings.includes(:listing, :user)
                                    .order(created_at: :desc)
                                    .limit(10)

    @pending_bookings = host_bookings.where(status: "pending")
                                     .includes(:listing, :user)
                                     .order(start_time: :asc)

    @total_earnings  = host_bookings.where(status: "completed").sum(:total_price)
    @pending_count   = @pending_bookings.count
    @gateway_configs = current_user.gateway_configs.index_by(&:gateway)

    @recent_reviews = Review.joins(:listing)
                            .where(listings: { user_id: current_user.id })
                            .includes(:user, :listing)
                            .order(created_at: :desc)
                            .limit(5)


    # Monthly revenue for the last 6 months
    @monthly_revenue = host_bookings
      .where(status: "completed")
      .where(start_time: 6.months.ago.beginning_of_month..)
      .group("DATE_TRUNC('month', start_time)")
      .sum(:total_price)
      .transform_keys { |k| k.strftime("%b %Y") }

    # Fill in missing months with 0
    @revenue_labels = (5.downto(0)).map { |n| n.months.ago.strftime("%b %Y") }.reverse
    @revenue_data   = @revenue_labels.map { |m| @monthly_revenue[m].to_f.round(2) }
  end

  def confirm_booking
    booking = Booking.joins(:listing)
                     .where(listings: { user_id: current_user.id })
                     .find(params[:booking_id])
    booking.update!(status: "confirmed")
    BookingNotificationService.new(booking).on_confirmed
    redirect_to host_root_path, notice: "Booking ##{booking.id} confirmed."
  end
end
