import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["window", "messages", "input", "badge", "suggestions"]

  history = []
  isOpen  = false

  connect() {
    this.addMessage("bot", "Hi! I'm SpaceBot 🤖 How can I help you find the perfect space today?")
  }

  toggle() {
    this.isOpen = !this.isOpen
    this.windowTarget.classList.toggle("d-none", !this.isOpen)
    if (this.isOpen) {
      this.badgeTarget.classList.add("d-none")
      this.inputTarget.focus()
      this.scrollToBottom()
    }
  }

  async send() {
    const text = this.inputTarget.value.trim()
    if (!text) return

    this.inputTarget.value = ""
    this.addMessage("user", text)
    this.showTyping()

    try {
      const response = await fetch("/chat/message", {
        method:  "POST",
        headers: { "Content-Type": "application/json" },
        body:    JSON.stringify({ message: text, history: this.history })
      })
      const data = await response.json()
      this.removeTyping()

      if (data.reply) {
        this.addMessage("bot", data.reply)
        this.history.push({ role: "user",  content: text })
        this.history.push({ role: "model", content: data.reply })
        // Keep history to last 10 exchanges (20 messages)
        if (this.history.length > 20) this.history = this.history.slice(-20)
      } else {
        this.addMessage("bot", "Sorry, I couldn't process that. Please try again.")
      }
    } catch {
      this.removeTyping()
      this.addMessage("bot", "Connection error. Please try again.")
    }
  }

  suggest(event) {
    this.inputTarget.value = event.currentTarget.dataset.prompt
    this.suggestionsTarget.classList.add("d-none")
    this.send()
  }

  keydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.send()
    }
  }

  addMessage(role, text) {
    const isBot  = role === "bot"
    const div    = document.createElement("div")
    div.className = `d-flex mb-2 ${isBot ? "justify-content-start" : "justify-content-end"}`
    div.innerHTML = `
      <div class="px-3 py-2 rounded-3 small" style="max-width:80%;white-space:pre-wrap;
           background:${isBot ? "#f1f3f5" : "#212529"};
           color:${isBot ? "#212529" : "#fff"};">
        ${this.escapeHtml(text)}
      </div>`
    this.messagesTarget.appendChild(div)
    this.scrollToBottom()
  }

  showTyping() {
    const div = document.createElement("div")
    div.id = "chatbot-typing"
    div.className = "d-flex mb-2 justify-content-start"
    div.innerHTML = `
      <div class="px-3 py-2 rounded-3 small bg-light text-muted fst-italic">
        SpaceBot is typing…
      </div>`
    this.messagesTarget.appendChild(div)
    this.scrollToBottom()
  }

  removeTyping() {
    document.getElementById("chatbot-typing")?.remove()
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  escapeHtml(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
  }
}
