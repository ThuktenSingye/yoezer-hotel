import { Controller } from "@hotwired/stimulus"
import { toggle} from 'el-transition';

// Connects to data-controller="avatar"
export default class extends Controller {
  static targets = ["avatarUpload"]

  selectImage(){
    this.avatarUploadTarget.click()
    toggle(this.avatarUploadTarget)
  }
}
