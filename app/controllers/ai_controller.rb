class AiController < UserApplicationController

  def generate_description
    title     = params[:title].to_s.strip
    category  = params[:category].to_s
    city      = params[:city].to_s
    amenities = params[:amenities].to_s

    if title.blank?
      render json: { error: "Title is required" }, status: :unprocessable_entity and return
    end

    description = AnthropicService.generate_listing_description(
      title: title, category: category, city: city, amenities: amenities
    )
    render json: { description: description }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def suggest_price
    category  = params[:category].to_s
    city      = params[:city].to_s
    capacity  = params[:capacity].to_s
    amenities = params[:amenities].to_s

    if category.blank? || city.blank?
      render json: { error: "Category and city are required" }, status: :unprocessable_entity and return
    end

    result = GeminiService.suggest_price(
      category: category, city: city, capacity: capacity, amenities: amenities
    )
    render json: result
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
