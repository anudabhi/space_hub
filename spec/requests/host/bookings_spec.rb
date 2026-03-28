
RSpec.describe "Host::Bookings", type: :request do
  let(:host)         { create(:user, :host) }
  let(:host_listing) { create(:listing, user: host) }

  before { sign_in host }

  # ── Index ────────────────────────────────────────────────────────────────────
  describe "GET /host/bookings" do
    it "returns 200" do
      get host_bookings_path
      expect(response).to have_http_status(:ok)
    end

    it "shows only bookings on host's own listings" do
      own    = create(:booking, listing: host_listing)
      other  = create(:booking)
      get host_bookings_path
      expect(response.body).to include("##{own.id}")
      expect(response.body).not_to include("##{other.id}")
    end

    context "status filter" do
      it "returns only pending bookings when status=pending" do
        pending_b   = create(:booking, listing: host_listing, status: "pending")
        confirmed_b = create(:booking, :confirmed, listing: host_listing)
        get host_bookings_path, params: { status: "pending" }
        expect(response.body).to include("##{pending_b.id}")
        expect(response.body).not_to include("##{confirmed_b.id}")
      end

      it "returns all bookings when status=all" do
        pending_b   = create(:booking, listing: host_listing, status: "pending")
        confirmed_b = create(:booking, :confirmed, listing: host_listing)
        get host_bookings_path, params: { status: "all" }
        expect(response.body).to include("##{pending_b.id}")
        expect(response.body).to include("##{confirmed_b.id}")
      end
    end

    context "date range filter" do
      it "filters bookings by from date" do
        future = create(:booking, listing: host_listing,
                        start_time: 5.days.from_now, end_time: 5.days.from_now + 2.hours)
        past   = create(:booking, listing: host_listing,
                        start_time: 10.days.ago, end_time: 10.days.ago + 2.hours)
        get host_bookings_path, params: { from: 1.day.ago.to_date.to_s }
        expect(response.body).to include("##{future.id}")
        expect(response.body).not_to include("##{past.id}")
      end

      it "filters bookings by to date" do
        past   = create(:booking, listing: host_listing,
                        start_time: 10.days.ago, end_time: 10.days.ago + 2.hours)
        future = create(:booking, listing: host_listing,
                        start_time: 5.days.from_now, end_time: 5.days.from_now + 2.hours)
        get host_bookings_path, params: { to: 1.day.ago.to_date.to_s }
        expect(response.body).to include("##{past.id}")
        expect(response.body).not_to include("##{future.id}")
      end
    end
  end

  # ── Show ─────────────────────────────────────────────────────────────────────
  describe "GET /host/bookings/:id" do
    it "returns 200 for a booking on own listing" do
      booking = create(:booking, listing: host_listing)
      get host_booking_path(booking)
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for another host's booking" do
      other_booking = create(:booking)
      get host_booking_path(other_booking)
      expect(response).to have_http_status(:not_found)
    end
  end

  # ── Confirm ──────────────────────────────────────────────────────────────────
  describe "PATCH /host/bookings/:id/confirm" do
    it "confirms a pending booking on own listing" do
      booking = create(:booking, listing: host_listing, status: "pending")
      patch confirm_host_booking_path(booking)

      expect(booking.reload.status).to eq("confirmed")
      expect(response).to redirect_to(host_booking_path(booking))
    end

    it "cannot confirm a booking on another host's listing" do
      other_booking = create(:booking, status: "pending")
      patch confirm_host_booking_path(other_booking)
      expect(response).to have_http_status(:not_found)
    end
  end

  # ── Complete ─────────────────────────────────────────────────────────────────
  describe "PATCH /host/bookings/:id/complete" do
    it "marks a confirmed booking as completed" do
      booking = create(:booking, :confirmed, listing: host_listing)
      patch complete_host_booking_path(booking)

      expect(booking.reload.status).to eq("completed")
      expect(response).to redirect_to(host_booking_path(booking))
    end

    it "cannot complete a booking on another host's listing" do
      other_booking = create(:booking, :confirmed)
      patch complete_host_booking_path(other_booking)
      expect(response).to have_http_status(:not_found)
    end
  end
end
