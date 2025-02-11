import { Controller } from "@hotwired/stimulus"
import { toggle} from 'el-transition';

// Connects to data-controller="reservation-date-validation"
export default class extends Controller {
  static targets = ['checkinDate', 'checkoutDate', 'dialogContent', 'dialog', 'numOfAdult', 'numOfChildren']
  validateDates(event) {
    const checkinDate = this.checkinDateTarget.value;
    const checkoutDate = this.checkoutDateTarget.value;
    const numOfAdult = this.numOfAdultTarget.value;
    const numOfChildren = this.numOfChildrenTarget.value;

    if (!checkinDate || !checkoutDate) {
      alert('Please fill in both Check-In and Check-Out dates.');
      event.preventDefault();
      return
    }

    if (!numOfChildren || !numOfAdult) {
      alert('Please fill in Adult and Children number.');
      event.preventDefault();
      return
    }

    this.dialogTarget.showModal()
  }
}
