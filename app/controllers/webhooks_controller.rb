class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def razorpay
    payload = request.body.read
    signature = request.headers["X-Razorpay-Signature"]
    secret = ENV["RAZORPAY_WEBHOOK_SECRET"]

    generated = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
    unless Rack::Utils.secure_compare(generated, signature.to_s)
      render json: { error: "Invalid signature" }, status: :unauthorized and return
    end

    event = JSON.parse(payload)
    if event["event"] == "payment.captured"
      payment_id = event.dig("payload", "payment", "entity", "id")
      notes = event.dig("payload", "payment", "entity", "notes") || {}
      booking_id = notes["booking_id"]
      booking = Booking.find_by(id: booking_id)
      booking&.update!(status: "confirmed", payment_id: payment_id)
    end

    head :ok
  end

  def stripe
    payload = request.body.read
    sig_header = request.headers["Stripe-Signature"]
    secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, secret)
    rescue Stripe::SignatureVerificationError
      render json: { error: "Invalid signature" }, status: :unauthorized and return
    end

    if event["type"] == "checkout.session.completed"
      session = event["data"]["object"]
      booking_id = session.dig("metadata", "booking_id")
      booking = Booking.find_by(id: booking_id)
      booking&.update!(status: "confirmed", payment_id: session["payment_intent"])
    end

    head :ok
  end
end
