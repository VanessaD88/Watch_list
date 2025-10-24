import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.scrollToBottom()
  }

  // Call this method whenever a new message is added
  scrollToBottom() {
    const container = this.containerTarget
    container.scrollTop = container.scrollHeight
  }
}
