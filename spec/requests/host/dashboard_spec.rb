RSpec.describe "Host::Dashboard", type: :request do
  let(:host)  { create(:user, :host) }
  let(:guest) { create(:user) }

  describe "GET /host" do
    context "when not signed in" do
      it "redirects to sign in" do
        get host_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as guest" do
      before { sign_in guest }

      it "redirects to root" do
        get host_root_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when signed in as host" do
      before { sign_in host }

      it "returns 200" do
        get host_root_path
        expect(response).to have_http_status(:ok)
      end

      it "shows pending bookings count" do
        listing = create(:listing, user: host)
        create_list(:booking, 2, listing: listing, status: "pending")
        get host_root_path
        expect(response.body).to include("2")
      end

      it "shows total earnings from completed bookings" do
        listing = create(:listing, user: host, price_per_hour: 1000)
        create(:booking, :completed, listing: listing, total_price: 2000)
        get host_root_path
        expect(response.body).to include("2,000")
      end
    end
  end

  describe "PATCH /host/dashboard/confirm_booking" do
    before { sign_in host }

    it "confirms a pending booking on own listing" do
      listing = create(:listing, user: host)
      booking = create(:booking, listing: listing, status: "pending")
      patch host_dashboard_confirm_booking_path, params: { booking_id: booking.id }

      expect(booking.reload.status).to eq("confirmed")
      expect(response).to redirect_to(host_root_path)
    end

    it "cannot confirm a booking on another host's listing" do
      other_booking = create(:booking, status: "pending")
      patch host_dashboard_confirm_booking_path, params: { booking_id: other_booking.id }
      expect(response).to have_http_status(:not_found)
    end
  end
end
