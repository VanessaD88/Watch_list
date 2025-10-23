import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]
  connect() {
  this.outsideClickListener = this.handleOutsideClick.bind(this)
  }

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("d-none")

    if (!this.menuTarget.classList.contains("d-none")) {
      document.addEventListener("click", this.outsideClickListener)
    } else {
      document.removeEventListener("click", this.outsideClickListener)
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("d-none")
      document.removeEventListener("click", this.outsideClickListener)
    }
  }
}
