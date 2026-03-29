RSpec.describe "Hosts", type: :request do
  describe "GET /hosts/:id" do
    let(:host)  { create(:user, :host) }
    let(:guest) { create(:user) }

    it "returns 200 for an approved host" do
      get host_path(host)
      expect(response).to have_http_status(:ok)
    end

    it "shows the host's name and bio" do
      host.update!(bio: "I love creating spaces.")
      get host_path(host)
      expect(response.body).to include(host.display_name)
      expect(response.body).to include("I love creating spaces.")
    end

    it "shows active listings" do
      listing = create(:listing, user: host, status: "active")
      get host_path(host)
      expect(response.body).to include(listing.title)
    end

    it "does not show draft listings" do
      draft = create(:listing, :draft, user: host)
      get host_path(host)
      expect(response.body).not_to include(draft.title)
    end

    it "returns 404 for a non-host user" do
      get host_path(guest)
      expect(response).to have_http_status(:not_found)
    end
  end
end
