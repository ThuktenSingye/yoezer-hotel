import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-validation"
export default class extends Controller {
  static targets = ["checkinDate", "checkoutDate", "numOfAdult","numOfChildren", 'dialog']
  validate(){
    const checkinDate = this.checkinDateTarget.value;
    const checkoutDate = this.checkoutDateTarget.value;
    const numOfAdult = this.numOfAdultTarget.value;
    const numOfChildren = this.numOfChildrenTarget.value;

    if (!checkoutDate || !checkinDate){
      alert("Fill in Checkout and Checkin Date!")
      return
    }

    if (!this.isValidNumber(numOfAdult) || !this.isValidNumber(numOfChildren)) {
      alert("Fill in correct adult and children numbers (positive integers only).");
      return;
    }
    this.dialogTarget.showModal();
  }

  isValidNumber(value) {
    return !isNaN(value) && Number.isInteger(parseFloat(value)) && parseFloat(value) >= 0;
  }
}
