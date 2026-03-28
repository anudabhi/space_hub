import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { labels: Array, data: Array }

  connect() {
    const ctx = this.element.getContext("2d")

    new window.Chart(ctx, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: "Revenue (₹)",
          data: this.dataValue,
          backgroundColor: "rgba(255, 193, 7, 0.7)",
          borderColor: "rgba(255, 193, 7, 1)",
          borderWidth: 1,
          borderRadius: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: ctx => "₹" + ctx.parsed.y.toLocaleString("en-IN")
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: val => "₹" + val.toLocaleString("en-IN")
            }
          }
        }
      }
    })
  }
}
