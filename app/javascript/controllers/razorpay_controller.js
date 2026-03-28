import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    bookingId: String,
    description: String
  }

  pay() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch("/payments/razorpay/create_order", {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": csrfToken },
      body: JSON.stringify({ booking_id: this.bookingIdValue })
    })
    .then(r => r.json())
    .then(data => {
      if (data.error) { alert(data.error); return }

      const rzp = new Razorpay({
        key:      data.key,
        amount:   data.amount,
        currency: "INR",
        order_id: data.order_id,
        name:     "SpaceHub India",
        description: this.descriptionValue,
        handler: (response) => {
          fetch("/payments/razorpay/verify", {
            method: "POST",
            headers: { "Content-Type": "application/json", "X-CSRF-Token": csrfToken },
            body: JSON.stringify({ booking_id: this.bookingIdValue, ...response })
          })
          .then(r => r.json())
          .then(d => { if (d.redirect_url) window.location.href = d.redirect_url })
        }
      })
      rzp.open()
    })
  }
}
