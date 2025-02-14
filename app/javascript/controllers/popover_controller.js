import { Controller } from "@hotwired/stimulus"
import { toggle} from 'el-transition';

// Connects to data-controller="popover"
export default class extends Controller {
  static  targets = ["popover", "backdrop"]

  toggle() {
    toggle(this.popoverTarget)
    this.backdropTarget.classList.toggle('hidden')
  }
}
