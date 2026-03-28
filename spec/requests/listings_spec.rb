
RSpec.describe "Listings", type: :request do
  describe "GET /listings" do
    before { create_list(:listing, 3, status: "active") }

    it "returns 200" do
      get listings_path
      expect(response).to have_http_status(:ok)
    end

    it "does not surface draft listings" do
      draft = create(:listing, :draft, title: "Secret Draft Listing")
      get listings_path
      expect(response.body).not_to include("Secret Draft Listing")
    end

    it "filters by city" do
      mumbai = create(:listing, city: "Mumbai", title: "Mumbai Space")
      _delhi = create(:listing, city: "Delhi",  title: "Delhi Space")

      get listings_path, params: { city: "Mumbai" }
      expect(response.body).to include("Mumbai Space")
      expect(response.body).not_to include("Delhi Space")
    end

    it "filters by category" do
      wellness = create(:listing, :wellness, title: "Spa Room")
      _events  = create(:listing, :events,   title: "Party Hall")

      get listings_path, params: { category: "wellness" }
      expect(response.body).to include("Spa Room")
      expect(response.body).not_to include("Party Hall")
    end
  end

  describe "GET /listings/:id" do
    it "returns 200 for an active listing" do
      listing = create(:listing, status: "active")
      get listing_path(listing)
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for a draft listing" do
      draft = create(:listing, :draft)
      get listing_path(draft)
      expect(response).to have_http_status(:not_found)
    end
  end
end
