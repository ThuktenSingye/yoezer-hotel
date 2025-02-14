import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]

  connect() {
    this.index = 0
    this.showCurrentSlide()
    this.startAutoSlide()
  }

  next() {
    this.index = (this.index + 1) % this.slideTargets.length
    this.showCurrentSlide()
  }

  prev() {
    this.index = (this.index - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("opacity-100", i === this.index)
      slide.classList.toggle("opacity-0", i !== this.index)
    })
  }

  startAutoSlide() {
    this.interval = setInterval(() => this.next(), 5000)
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
