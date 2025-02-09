import { Controller } from "@hotwired/stimulus"
import { toggle} from 'el-transition';

// Connects to data-controller="reservation-date-validation"
export default class extends Controller {
  static targets = ['checkinDate', 'checkoutDate', 'dialogContent', 'dialog']
  validateDates(event) {
    const checkinDate = this.checkinDateTarget.value;
    const checkoutDate = this.checkoutDateTarget.value;

    if (!checkinDate || !checkoutDate) {
      alert('Please fill in both Check-In and Check-Out dates.');
      event.preventDefault();
    } else {
      this.dialogTarget.showModal()
    }
  }
}
