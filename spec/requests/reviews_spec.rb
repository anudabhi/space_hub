
RSpec.describe "Reviews", type: :request do
  let(:guest)   { create(:user) }
  let(:listing) { create(:listing, status: "active") }

  describe "POST /listings/:listing_id/reviews" do
    context "with a completed booking" do
      let!(:booking) { create(:booking, :completed, user: guest, listing: listing) }

      before { sign_in guest }

      it "creates a review" do
        expect {
          post listing_reviews_path(listing), params: {
            review: { rating: 5, body: "Absolutely fantastic space, loved every minute!" }
          }
        }.to change(Review, :count).by(1)
      end

      it "redirects to the listing" do
        post listing_reviews_path(listing), params: {
          review: { rating: 4, body: "Great space with excellent amenities overall." }
        }
        expect(response).to redirect_to(listing_path(listing))
      end

      it "does not allow a second review on the same booking" do
        create(:review, booking: booking, listing: listing, user: guest, rating: 5)

        expect {
          post listing_reviews_path(listing), params: {
            review: { rating: 3, body: "Actually I changed my mind about this one." }
          }
        }.not_to change(Review, :count)
      end
    end

    context "without a completed booking" do
      before { sign_in guest }

      it "does not create a review and redirects with alert" do
        expect {
          post listing_reviews_path(listing), params: {
            review: { rating: 5, body: "Great place but I never booked it." }
          }
        }.not_to change(Review, :count)

        expect(response).to redirect_to(listing_path(listing))
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        post listing_reviews_path(listing), params: {
          review: { rating: 5, body: "Good space." }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
