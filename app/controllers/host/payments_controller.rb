class Host::PaymentsController < HostApplicationController
  def index
    @payments = Booking.joins(:listing)
                       .where(listings: { user_id: current_user.id })
                       .where.not(payment_id: nil)
                       .includes(:listing, :user)
                       .order(updated_at: :desc)

    @payments = @payments.where(payment_gateway: params[:gateway]) if params[:gateway].present?

    if params[:from].present?
      @payments = @payments.where("bookings.updated_at >= ?", Date.parse(params[:from]).beginning_of_day)
    end
    if params[:to].present?
      @payments = @payments.where("bookings.updated_at <= ?", Date.parse(params[:to]).end_of_day)
    end

    @total      = @payments.sum(:total_price)
    @by_gateway = @payments.reorder(nil).group(:payment_gateway).sum(:total_price)
  end
end
