class PaymentsController < UserApplicationController
  skip_before_action :authenticate_user!, only: %i[stripe_success stripe_cancel]

  # POST /payments/razorpay/create_order
  def razorpay_create_order
    booking = current_user.bookings.find(params[:booking_id])
    amount_paise = (booking.total_price * 100).to_i
    rzp = razorpay_config_for(booking)

    Razorpay.setup(rzp[:key_id], rzp[:key_secret])
    order = Razorpay::Order.create(
      amount: amount_paise,
      currency: "INR",
      receipt: "booking_#{booking.id}",
      notes: { booking_id: booking.id }
    )

    booking.update!(payment_order_id: order.id, payment_gateway: "razorpay")
    render json: { order_id: order.id, amount: amount_paise, key: rzp[:key_id] }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /payments/razorpay/verify
  def razorpay_verify
    booking = current_user.bookings.find(params[:booking_id])
    rzp = razorpay_config_for(booking)

    generated_signature = OpenSSL::HMAC.hexdigest(
      "SHA256",
      rzp[:key_secret],
      "#{params[:razorpay_order_id]}|#{params[:razorpay_payment_id]}"
    )

    if generated_signature == params[:razorpay_signature]
      booking.update!(status: "confirmed", payment_id: params[:razorpay_payment_id])
      Payment.create!(
        booking: booking,
        gateway: "razorpay",
        order_id: params[:razorpay_order_id],
        payment_id: params[:razorpay_payment_id],
        amount: booking.total_price,
        currency: "INR",
        status: "captured",
        raw_response: params.to_json
      )
      render json: { status: "success", redirect_url: guest_booking_path(booking) }
    else
      render json: { error: "Payment verification failed" }, status: :unprocessable_entity
    end
  end

  # POST /payments/stripe/create_session
  def stripe_create_session
    booking = current_user.bookings.find(params[:booking_id])
    stripe_key = stripe_secret_key_for(booking)

    session = Stripe::Checkout::Session.create(
      {
        payment_method_types: [ "card" ],
        line_items: [ {
          price_data: {
            currency: "inr",
            product_data: { name: booking.listing.title },
            unit_amount: (booking.total_price * 100).to_i
          },
          quantity: 1
        } ],
        mode: "payment",
        success_url: stripe_success_url(booking_id: booking.id, session_id: "{CHECKOUT_SESSION_ID}"),
        cancel_url: stripe_cancel_url(booking_id: booking.id),
        metadata: { booking_id: booking.id }
      },
      { api_key: stripe_key }
    )

    booking.update!(payment_order_id: session.id, payment_gateway: "stripe")
    render json: { session_url: session.url }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /payments/stripe/success
  def stripe_success
    booking = Booking.find(params[:booking_id])
    stripe_key = stripe_secret_key_for(booking)
    session = Stripe::Checkout::Session.retrieve(params[:session_id], {}, { api_key: stripe_key })

    if session.payment_status == "paid"
      booking.update!(status: "confirmed", payment_id: session.payment_intent)
      Payment.find_or_create_by!(booking: booking) do |p|
        p.gateway    = "stripe"
        p.order_id   = session.id
        p.payment_id = session.payment_intent
        p.amount     = booking.total_price
        p.currency   = "INR"
        p.status     = "captured"
      end
      redirect_to guest_booking_path(booking), notice: "Payment successful! Booking confirmed."
    else
      redirect_to guest_booking_path(booking), alert: "Payment not completed."
    end
  end

  # GET /payments/stripe/cancel
  def stripe_cancel
    booking = Booking.find(params[:booking_id])
    redirect_to guest_booking_path(booking), alert: "Payment cancelled."
  end

  private

  def razorpay_config_for(booking)
    host = booking.listing.user
    cfg  = host.gateway_config_for("razorpay")
    if cfg
      { key_id: cfg.key_id, key_secret: cfg.key_secret }
    else
      { key_id: ENV["RAZORPAY_KEY_ID"], key_secret: ENV["RAZORPAY_KEY_SECRET"] }
    end
  end

  def stripe_secret_key_for(booking)
    host = booking.listing.user
    cfg  = host.gateway_config_for("stripe")
    cfg ? cfg.key_secret : ENV["STRIPE_SECRET_KEY"]
  end
end
