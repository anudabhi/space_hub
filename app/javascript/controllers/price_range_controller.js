import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["minSlider", "maxSlider", "minDisplay", "maxDisplay", "minInput", "maxInput"]

  connect() {
    this.update()
  }

  update() {
    const min = parseInt(this.minSliderTarget.value)
    const max = parseInt(this.maxSliderTarget.value)

    if (min > max) {
      this.minSliderTarget.value = max
    }

    this.minDisplayTarget.textContent = "₹" + parseInt(this.minSliderTarget.value).toLocaleString("en-IN")
    this.maxDisplayTarget.textContent = "₹" + parseInt(this.maxSliderTarget.value).toLocaleString("en-IN")
    this.minInputTarget.value = this.minSliderTarget.value
    this.maxInputTarget.value = this.maxSliderTarget.value
  }
}
