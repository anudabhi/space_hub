import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "city", "capacity", "amenities", "price", "button", "result"]

  async suggest() {
    const category = this.categoryTarget.value
    const city     = this.cityTarget.value

    if (!category || !city) {
      this.showResult("Please select a category and city first.", "warning")
      return
    }

    this.buttonTarget.disabled = true
    this.buttonTarget.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Asking Gemini...'
    this.resultTarget.classList.add("d-none")

    try {
      const response = await fetch("/ai/suggest_price", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          category,
          city,
          capacity:  this.capacityTarget.value,
          amenities: this.amenitiesTarget.value
        })
      })

      const data = await response.json()

      if (data.error) {
        this.showResult(data.error, "danger")
      } else {
        this.showResult(
          `<strong>Suggested: ₹${data.price.toLocaleString("en-IN")}/hr</strong>
           <span class="text-muted ms-2">(Range: ₹${data.min.toLocaleString("en-IN")} – ₹${data.max.toLocaleString("en-IN")})</span>
           <p class="mb-0 mt-1 small text-muted">${data.reason}</p>`,
          "success",
          data.price
        )
      }
    } catch (err) {
      this.showResult("Failed to get suggestion. Please try again.", "danger")
    } finally {
      this.buttonTarget.disabled = false
      this.buttonTarget.innerHTML = '✨ Suggest Price'
    }
  }

  applyPrice(event) {
    const price = event.currentTarget.dataset.price
    this.priceTarget.value = price
    this.resultTarget.classList.add("d-none")
  }

  showResult(html, type, price = null) {
    const applyBtn = price
      ? `<button type="button" class="btn btn-sm btn-outline-success ms-2"
                 data-action="click->price-suggestion#applyPrice"
                 data-price="${price}">Apply ₹${price.toLocaleString("en-IN")}</button>`
      : ""

    this.resultTarget.className = `alert alert-${type} py-2 px-3 mt-2 small`
    this.resultTarget.innerHTML = html + applyBtn
    this.resultTarget.classList.remove("d-none")
  }
}
