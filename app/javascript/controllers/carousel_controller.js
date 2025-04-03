import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "dot"]
  static values = {
    interval: { type: Number, default: 5000 },
    currentIndex: { type: Number, default: 0 }
  }

  connect() {
    this.startSlideshow()
  }

  disconnect() {
    this.stopSlideshow()
  }

  startSlideshow() {
    this.slideshowInterval = setInterval(() => {
      this.next()
    }, this.intervalValue)
  }

  stopSlideshow() {
    clearInterval(this.slideshowInterval)
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % this.itemTargets.length
    this.showSlide()
  }

  previous() {
    this.currentIndexValue = (this.currentIndexValue - 1 + this.itemTargets.length) % this.itemTargets.length
    this.showSlide()
  }

  goToSlide(event) {
    this.currentIndexValue = parseInt(event.currentTarget.dataset.index)
    this.showSlide()
  }

  showSlide() {
    this.itemTargets.forEach((item, index) => {
      if (index === this.currentIndexValue) {
        item.classList.add("active")
      } else {
        item.classList.remove("active")
      }
    })

    this.dotTargets.forEach((dot, index) => {
      if (index === this.currentIndexValue) {
        dot.classList.add("active")
      } else {
        dot.classList.remove("active")
      }
    })
  }
}
