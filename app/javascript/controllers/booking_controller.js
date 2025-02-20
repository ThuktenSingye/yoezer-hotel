import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["successDialog", "errorDialog", "form", "dialog"];

  connect() {
    this.successDialog = this.successDialogTarget;
    this.errorDialog = this.errorDialogTarget;
  }

  async handleSubmit(event) {
    event.preventDefault();

    if (!this.formTarget.checkValidity()) {
      alert("Please fill in all inputs with correct details.");
      return;
    }

    try {
      const response = await fetch(this.formTarget.action, {
        method: this.formTarget.method,
        body: new FormData(this.formTarget),
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        },
      });

      const data = await response.json();

      if (response.ok) {
        this.dialogTarget.close();
        this.successDialogTarget.showModal();
      } else {
        this.showErrorDialog(data.message || "An error occurred. Please try again.");
      }
    } catch (error) {
      this.showErrorDialog("An error occurred. Please try again.");
    }
  }

  closeSuccessDialog() {
    this.successDialog.close();
    window.location.reload();
  }

  closeErrorDialog() {
    this.errorDialog.close();
    window.location.reload();
  }

  showErrorDialog(message) {
    const errorMessageElement = this.errorDialog.querySelector("[data-error-message]");
    if (errorMessageElement) {
      errorMessageElement.textContent = message;
    }
    this.dialogTarget.close();
    this.errorDialog.showModal();
  }
}