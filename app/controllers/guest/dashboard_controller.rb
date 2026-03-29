class Guest::DashboardController < GuestApplicationController
  def index
    @upcoming_bookings = current_user.bookings
                                     .includes(:listing)
                                     .upcoming
                                     .order(start_time: :asc)
    @past_bookings = current_user.bookings
                                 .includes(:listing)
                                 .past
                                 .order(start_time: :desc)
                                 .limit(5)
  end
end
