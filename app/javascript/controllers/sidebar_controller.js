import { Controller } from "@hotwired/stimulus"
import { toggle} from "el-transition";
// Connects to data-controller="dropdown"
export default class extends Controller {
  static  targets = ["menu", "sidebar", "backdrop"]
  toggle() {
    toggle(this.menuTarget);
  }
  toggleSidebar(event) {
    const sidebarToggleable = document.getElementById("sidebar-toggle")
    sidebarToggleable.classList.toggle('hidden')

    this.sidebarTarget.classList.toggle("-translate-x-full");
    this.backdropTarget.classList.toggle('hidden')
  }
}
