class ChatController < ApplicationController
  skip_before_action :verify_authenticity_token

  def message
    user_message = params[:message].to_s.strip
    history      = params[:history] || []

    if user_message.blank?
      render json: { error: "Message is required" }, status: :unprocessable_entity and return
    end

    reply = GeminiService.chat(message: user_message, history: history)
    render json: { reply: reply }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
