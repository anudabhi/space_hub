import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { bookingId: String }

  pay() {
    fetch("/payments/stripe/create_session", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ booking_id: this.bookingIdValue })
    })
    .then(r => r.json())
    .then(data => {
      if (data.session_url) window.location.href = data.session_url
      else alert(data.error)
    })
  }
}
