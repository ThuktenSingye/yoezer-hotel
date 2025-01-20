
import { Controller } from "@hotwired/stimulus"
import { toggle} from 'el-transition';

// Connects to data-controller="avatar"
export default class extends Controller {
  static targets = ["imagePreview", "avatarUpload"];

  selectImage(){
    this.avatarUploadTarget.click()
  }

  showPreview(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.imagePreviewTarget.src = reader.result;
        this.imagePreviewTarget.removeAttribute("hidden");
      };
      reader.readAsDataURL(file);
    }
  }
}