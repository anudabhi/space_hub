class GeminiService
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are SpaceBot, a helpful assistant for SpaceHub — India's premium marketplace for booking
    unique spaces by the hour: private spas, creative studios, and event venues across Mumbai,
    Delhi, Bangalore, Chennai, Hyderabad, and Pune.

    You help guests:
    - Find the right space (by city, category, capacity, budget)
    - Understand how booking works (hourly pricing, instant booking, host confirmation)
    - Learn about payment options (Razorpay for UPI/cards, Stripe for international cards)
    - Answer questions about cancellations, reviews, and the platform

    You help hosts:
    - Understand how to list a space
    - Learn about setting up payment gateways
    - Know how to manage bookings

    Keep answers concise, friendly, and warm. If asked about a specific listing or real-time
    availability, let the user know you don't have live data but guide them to use the Browse
    or Search feature. Never make up prices or availability. Always encourage users to explore
    the platform.
  PROMPT

  def self.chat(message:, history: [])
    contents = history.map do |msg|
      { role: msg["role"], parts: [ { text: msg["content"] } ] }
    end
    contents << { role: "user", parts: [ { text: message } ] }

    response = HTTParty.post(
      "#{API_URL}?key=#{ENV.fetch('GEMINI_API_KEY', '')}",
      headers: { "Content-Type" => "application/json" },
      body: {
        system_instruction: { parts: [ { text: SYSTEM_PROMPT } ] },
        contents:           contents,
        generationConfig:   { temperature: 0.7, maxOutputTokens: 1000 }
      }.to_json
    )

    raise "Gemini API error (#{response.code}): #{response.body}" unless response.success?

    parts = response.dig("candidates", 0, "content", "parts") || []
    parts.reject { |p| p["thought"] }.map { |p| p["text"] }.join.strip
  end

  def self.suggest_price(category:, city:, capacity:, amenities:)
    prompt = <<~PROMPT
      You are a pricing expert for SpaceHub, a premium hourly space rental marketplace in India.

      Suggest a price for this space:
      Category: #{category}
      City: #{city}
      Capacity: #{capacity} people
      Amenities: #{amenities}

      Reply with ONLY a raw JSON object, nothing else before or after it.
      Format: {"price":2500,"min":1800,"max":3500,"reason":"One sentence explanation."}
    PROMPT

    response = HTTParty.post(
      "#{API_URL}?key=#{ENV.fetch('GEMINI_API_KEY', '')}",
      headers: { "Content-Type" => "application/json" },
      body: {
        contents: [ { parts: [ { text: prompt } ] } ],
        generationConfig: { temperature: 0.2, maxOutputTokens: 2000 }
      }.to_json
    )

    raise "Gemini API error (#{response.code}): #{response.body}" unless response.success?

    # gemini-2.5-flash is a thinking model — skip thought parts, use only text parts
    parts = response.dig("candidates", 0, "content", "parts") || []
    raw   = parts.reject { |p| p["thought"] }.map { |p| p["text"] }.join.strip

    # Strip markdown fences if present
    raw = raw.gsub(/\A```(?:json)?\s*/, "").gsub(/\s*```\z/, "").strip

    # Extract the outermost JSON object
    json_str = raw[/\{.+\}/m]
    raise "No JSON in Gemini response: #{raw.truncate(200)}" if json_str.nil?

    JSON.parse(json_str)
  end
end
