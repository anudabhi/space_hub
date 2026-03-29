RSpec.describe "Chat", type: :request do
  describe "POST /chat/message" do
    context "with a blank message" do
      it "returns 422" do
        post chat_message_path, params: { message: "" }.to_json,
             headers: { "Content-Type" => "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to be_present
      end
    end

    context "with a valid message" do
      it "calls GeminiService.chat and returns a reply" do
        allow(GeminiService).to receive(:chat).and_return("SpaceHub has wellness, creative, and event spaces!")

        post chat_message_path,
             params:  { message: "What spaces do you have?", history: [] }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["reply"]).to eq("SpaceHub has wellness, creative, and event spaces!")
      end

      it "passes conversation history to GeminiService" do
        allow(GeminiService).to receive(:chat).and_return("How can I help?")

        post chat_message_path,
             params:  { message: "What's in Mumbai?", history: [ { role: "user", content: "Hi" } ] }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(GeminiService).to have_received(:chat).with(
          hash_including(message: "What's in Mumbai?")
        )
      end
    end

    context "when GeminiService raises an error" do
      it "returns 422 with error message" do
        allow(GeminiService).to receive(:chat).and_raise("API key missing")

        post chat_message_path,
             params:  { message: "Hello" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to include("API key missing")
      end
    end
  end
end
