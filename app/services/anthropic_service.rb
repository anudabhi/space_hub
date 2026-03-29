class AnthropicService
  API_URL = "https://api.anthropic.com/v1/messages"
  MODEL   = "claude-haiku-4-5-20251001"

  def self.generate_listing_description(title:, category:, city:, amenities:)
    prompt = <<~PROMPT
      Write a compelling, 3-paragraph listing description for a space rental marketplace targeting India's premium market.

      Space details:
      - Name: #{title}
      - Category: #{category} (wellness / creative / events)
      - City: #{city}
      - Amenities: #{amenities}

      Guidelines:
      - Paragraph 1: Evocative opening that paints a picture of the space
      - Paragraph 2: Highlight key amenities and what makes it unique
      - Paragraph 3: Who it's perfect for and a subtle call to action
      - Tone: warm, premium, aspirational — not salesy
      - Length: ~150 words total
    PROMPT

    response = HTTParty.post(
      API_URL,
      headers: {
        "x-api-key"         => ENV["ANTHROPIC_API_KEY"],
        "anthropic-version" => "2023-06-01",
        "content-type"      => "application/json"
      },
      body: {
        model: MODEL,
        max_tokens: 400,
        messages: [ { role: "user", content: prompt } ]
      }.to_json
    )

    raise "Anthropic API error: #{response.body}" unless response.success?

    data = JSON.parse(response.body)
    data.dig("content", 0, "text").to_s.strip
  end
end
