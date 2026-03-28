RSpec.describe "Host::Payments", type: :request do
  let(:host)  { create(:user, :host) }
  let(:guest) { create(:user) }

  describe "GET /host/payments" do
    context "when not signed in" do
      it "redirects to sign in" do
        get host_payments_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as guest" do
      before { sign_in guest }

      it "redirects to root" do
        get host_payments_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when signed in as host" do
      let(:listing) { create(:listing, user: host) }
      before { sign_in host }

      it "returns 200" do
        get host_payments_path
        expect(response).to have_http_status(:ok)
      end

      it "shows only bookings with a payment_id" do
        paid     = create(:booking, listing: listing, payment_id: "pay_123", payment_gateway: "razorpay")
        _unpaid  = create(:booking, listing: listing, payment_id: nil)
        get host_payments_path
        expect(response.body).to include("pay_123")
      end

      it "does not show bookings from other hosts" do
        other_booking = create(:booking, payment_id: "pay_other")
        get host_payments_path
        expect(response.body).not_to include("pay_other")
      end

      context "filtering by gateway" do
        it "returns only razorpay payments" do
          create(:booking, listing: listing, payment_id: "pay_rzp", payment_gateway: "razorpay")
          create(:booking, listing: listing, payment_id: "pay_str", payment_gateway: "stripe")
          get host_payments_path, params: { gateway: "razorpay" }
          expect(response.body).to include("pay_rzp")
          expect(response.body).not_to include("pay_str")
        end
      end

      context "filtering by date range" do
        it "filters payments by from date" do
          old = create(:booking, listing: listing, payment_id: "pay_old",
                       updated_at: 10.days.ago, payment_gateway: "razorpay")
          recent = create(:booking, listing: listing, payment_id: "pay_new",
                          payment_gateway: "razorpay")
          get host_payments_path, params: { from: 2.days.ago.to_date.to_s }
          expect(response.body).to include("pay_new")
          expect(response.body).not_to include("pay_old")
        end
      end
    end
  end
end
