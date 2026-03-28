RSpec.describe "AI", type: :request do
  let(:host) { create(:user, :host) }
  before { sign_in host }

  describe "POST /ai/suggest_price" do
    context "with missing required params" do
      it "returns 422 when category is blank" do
        post ai_suggest_price_path, params: { city: "Mumbai" }.to_json,
             headers: { "Content-Type" => "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns 422 when city is blank" do
        post ai_suggest_price_path, params: { category: "wellness" }.to_json,
             headers: { "Content-Type" => "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      it "returns price suggestion from GeminiService" do
        allow(GeminiService).to receive(:suggest_price).and_return(
          { "price" => 2500, "min" => 1800, "max" => 3500, "reason" => "Good rate for Mumbai wellness." }
        )

        post ai_suggest_price_path,
             params:  { category: "wellness", city: "Mumbai", capacity: "4", amenities: "WiFi, AC" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)
        expect(data["price"]).to eq(2500)
        expect(data["reason"]).to be_present
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        sign_out host
        post ai_suggest_price_path, params: { category: "wellness", city: "Mumbai" }.to_json,
             headers: { "Content-Type" => "application/json" }
        expect(response).to have_http_status(:unauthorized).or redirect_to(new_user_session_path)
      end
    end
  end
end
