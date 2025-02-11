import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["successDialog", "errorDialog", "form", "dialog"];

  connect() {
    this.successDialog = this.successDialogTarget;
    this.errorDialog = this.errorDialogTarget;
  }

  async handleSubmit(event) {
    event.preventDefault();

    if (this.validateForm()) {
      const isSuccess = await this.submitForm();
      if (isSuccess) {
        this.dialogTarget.close();
        this.successDialog.showModal();
      } else {
        this.showErrorDialog("An error occurred. Please try again by entering correct details.");
      }
    } else {
      alert("Please Fill in all Input with Correct Details. Thank you!.")
    }
  }

  validateForm() {
    return this.formTarget.checkValidity();
  }

  async submitForm() {
    const form = this.formTarget;
    const formData = new FormData(form);

    const csrfToken = document.querySelector("[name='csrf-token']").content

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          "X-CSRF-Token": csrfToken
        },
      });

      return response.ok
    } catch (error) {
      return false
    }
  }
  closeSuccessDialog() {
    this.successDialog.close();
    window.location.reload();
  }

  closeErrorDialog() {
    this.errorDialog.close();
    window.location.reload()
  }


  showErrorDialog(message) {
    const errorMessageElement = this.errorDialog.querySelector("[data-error-message]");
    if (errorMessageElement) {
      errorMessageElement.textContent = message;
    }
    this.dialogTarget.close()
    this.errorDialog.showModal();
  }
}
