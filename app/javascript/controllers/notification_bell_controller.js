import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  toggle(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.toggle("show")
  }

  close() {
    this.dropdownTarget.classList.remove("show")
  }

  // Close when clicking outside
  connect() {
    this.outsideClickHandler = (e) => {
      if (!this.element.contains(e.target)) this.close()
    }
    document.addEventListener("click", this.outsideClickHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler)
  }
}
