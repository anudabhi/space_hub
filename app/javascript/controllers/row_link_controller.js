import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  navigate(event) {
    // Don't navigate if clicking a link, button, or form inside the row
    if (event.target.closest("a, button, form")) return
    window.location.href = this.element.dataset.href
  }
}
