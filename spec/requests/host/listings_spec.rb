
RSpec.describe "Host::Listings", type: :request do
  let(:host)  { create(:user, :host) }
  let(:guest) { create(:user) }

  describe "GET /host/listings" do
    it "redirects guests" do
      sign_in guest
      get host_listings_path
      expect(response).to redirect_to(root_path)
    end

    it "returns 200 for host" do
      sign_in host
      get host_listings_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /host/listings" do
    let(:valid_params) do
      {
        listing: {
          title: "Test Studio",
          description: "A great space for creative work in the city.",
          category: "creative",
          city: "Mumbai",
          address: "Bandra West",
          price_per_hour: 1500,
          capacity: 10,
          amenities: "WiFi, AC"
        }
      }
    end

    context "as a host" do
      before { sign_in host }

      it "creates a listing" do
        expect {
          post host_listings_path, params: valid_params
        }.to change(Listing, :count).by(1)
      end

      it "assigns the listing to the current host" do
        post host_listings_path, params: valid_params
        expect(Listing.last.user).to eq(host)
      end

      it "sets status to active" do
        post host_listings_path, params: valid_params
        expect(Listing.last.status).to eq("active")
      end
    end

    context "as a guest" do
      before { sign_in guest }

      it "does not create a listing" do
        expect {
          post host_listings_path, params: valid_params
        }.not_to change(Listing, :count)
      end
    end
  end

  describe "DELETE /host/listings/:id" do
    before { sign_in host }

    it "destroys the host's own listing" do
      listing = create(:listing, user: host)
      expect {
        delete host_listing_path(listing)
      }.to change(Listing, :count).by(-1)
    end

    it "cannot destroy another host's listing" do
      other_listing = create(:listing)
      expect {
        delete host_listing_path(other_listing)
      }.not_to change(Listing, :count)
    end
  end
end
