class ReviewsController < UserApplicationController
  before_action :set_listing

  def create
    booking = current_user.bookings.find_by(listing: @listing, status: "completed")
    unless booking
      redirect_to @listing, alert: "You can only review spaces you have booked and completed."
      return
    end

    if booking.review.present?
      redirect_to @listing, alert: "You have already reviewed this space."
      return
    end

    @review = @listing.reviews.build(review_params)
    @review.booking = booking
    @review.user = current_user

    if @review.save
      redirect_to @listing, notice: "Review submitted. Thank you!"
    else
      redirect_to @listing, alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
