  // app/javascript/controllers/booking_success_controller.js
  import { Controller } from "@hotwired/stimulus";

  export default class extends Controller {
    static targets = ["successDialog", "form", "dialog"];

    connect() {
      this.successDialog = this.successDialogTarget;
    }

    async showSuccessDialog(event) {
      this.dialogTarget.close()
      this.successDialogTarget.showModal();
    }

    closeSuccessDialog() {
      this.successDialogTarget.close();
    }
  }
