import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["starButton", "star"]

  mouseOver(event) {
    const index = this.starButtonTargets.indexOf(event.target.closest('.star-button'));

    if (index !== -1) {
      this.highlightStars(index);
    }
  }

  mouseOut() {
    this.resetStars();
  }

  highlightStars(index) {
    this.starTargets.forEach((star, i) => {
      console.log(`i- ${star}`, i)

      if (i <= index) {
        star.classList.add("active");
      } else {
        star.classList.remove("active");
      }
    });
  }

  resetStars() {
    console.log("Resetting stars"); // Debugging
    this.starTargets.forEach(star => {
      star.classList.remove("active");
    });
  }
}