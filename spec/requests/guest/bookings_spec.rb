
RSpec.describe "Guest::Bookings", type: :request do
  let(:guest) { create(:user) }
  let(:other) { create(:user) }

  describe "GET /guest/bookings" do
    context "when not signed in" do
      it "redirects to sign in" do
        get guest_bookings_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in guest }

      it "returns 200" do
        get guest_bookings_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /guest/bookings/:id" do
    context "when accessing own booking" do
      before { sign_in guest }

      it "returns 200" do
        booking = create(:booking, user: guest)
        get guest_booking_path(booking)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when accessing another user's booking" do
      before { sign_in guest }

      it "returns 404" do
        other_booking = create(:booking, user: other)
        get guest_booking_path(other_booking)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /guest/bookings/:id/cancel" do
    before { sign_in guest }

    it "cancels a pending booking" do
      booking = create(:booking, user: guest, status: "pending")
      patch cancel_guest_booking_path(booking)

      expect(booking.reload.status).to eq("cancelled")
      expect(response).to redirect_to(guest_bookings_path)
    end

    it "cancels a confirmed booking" do
      booking = create(:booking, :confirmed, user: guest)
      patch cancel_guest_booking_path(booking)
      expect(booking.reload.status).to eq("cancelled")
    end

    it "does not cancel a completed booking" do
      booking = create(:booking, :completed, user: guest)
      patch cancel_guest_booking_path(booking)
      expect(booking.reload.status).to eq("completed")
    end
  end
end
