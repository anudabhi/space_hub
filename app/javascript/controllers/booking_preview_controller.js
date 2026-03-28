import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startTime", "endTime", "preview", "hours", "total"]
  static values  = { pricePerHour: Number }

  connect() {
    this.update()
  }

  update() {
    const start = new Date(this.startTimeTarget.value)
    const end   = new Date(this.endTimeTarget.value)

    if (!this.startTimeTarget.value || !this.endTimeTarget.value || end <= start) {
      this.previewTarget.classList.add("d-none")
      return
    }

    const hours = (end - start) / 3_600_000
    const total = (hours * this.pricePerHourValue).toFixed(0)

    this.hoursTarget.textContent  = hours % 1 === 0 ? hours : hours.toFixed(1)
    this.totalTarget.textContent  = "₹" + Number(total).toLocaleString("en-IN")
    this.previewTarget.classList.remove("d-none")
  }
}
