// app/javascript/controllers/flatpickr_controller.js
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

export default class extends Controller {
  connect() {
    const minDate = this.data.get("min-date");
    const maxDate = this.data.get("max-date");
    flatpickr(this.element, {
      dateFormat: "Y-m-d",
      disableMobile: true,
      minDate: minDate,
      maxDate: maxDate
    });
  }
}
