
RSpec.describe "Bookings", type: :request do
  let(:guest)   { create(:user) }
  let(:listing) { create(:listing, status: "active", price_per_hour: 1000) }

  describe "GET /listings/:listing_id/bookings/new" do
    context "when not signed in" do
      it "redirects to sign in" do
        get new_listing_booking_path(listing)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in guest }

      it "returns 200" do
        get new_listing_booking_path(listing)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /listings/:listing_id/bookings" do
    let(:valid_params) do
      {
        booking: {
          start_time: 5.days.from_now.change(hour: 10).iso8601,
          end_time:   5.days.from_now.change(hour: 12).iso8601,
          payment_gateway: "razorpay"
        }
      }
    end

    context "when not signed in" do
      it "redirects to sign in" do
        post listing_bookings_path(listing), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as guest" do
      before { sign_in guest }

      it "creates a booking and redirects to booking payment page" do
        expect {
          post listing_bookings_path(listing), params: valid_params
        }.to change(Booking, :count).by(1)

        expect(response).to redirect_to(guest_booking_path(Booking.last))
      end

      it "sets correct total_price" do
        post listing_bookings_path(listing), params: valid_params
        expect(Booking.last.total_price).to eq(2000.0)
      end

      it "sets status to pending" do
        post listing_bookings_path(listing), params: valid_params
        expect(Booking.last.status).to eq("pending")
      end

      it "does not create booking with invalid times" do
        params = valid_params.deep_merge(booking: {
          start_time: 5.days.from_now.change(hour: 14).iso8601,
          end_time:   5.days.from_now.change(hour: 10).iso8601
        })

        expect {
          post listing_bookings_path(listing), params: params
        }.not_to change(Booking, :count)
      end
    end
  end
end
