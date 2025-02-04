import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["imagesContainer", "imagesUpload", "imageInput", "existingImageContainer"];

  selectImage() {
    this.imageInputTarget.click();
  }

  addImage(event) {
    event.preventDefault();
    const files = Array.from(this.imageInputTarget.files);

    files.forEach((file) => {
      const reader = new FileReader();
      reader.onload = () => {
        const newImageHtml = `
          <div class="relative my-2 " data-image-id="${file.name}" data-controller="image">
            <div class="image-cropper">
              <img src="${reader.result}" class="rounded object-cover w-full h-full" />
            </div>
            <div
              class="flex items-center text-center absolute -top-4 -right-4 avatar-cropper icon hover:cursor-pointer z-10"
              data-action="click->image#removeImage" data-image-id="${file.name}">
              <i class="fa-solid fa-xmark w-full text-primary-regular"></i>
            </div>
          </div>
        `;
        this.imagesContainerTarget.insertAdjacentHTML("beforeend", newImageHtml);
      };
      reader.readAsDataURL(file);
    });
  }

  removeExistingImage(event) {
    event.currentTarget.closest('[data-image-target="existingImageContainer"]').remove();
  }

  removeImage(event) {
    event.preventDefault();
    const imageElement = event.currentTarget.closest(".relative");

    if (imageElement) {
      const imageId = imageElement.dataset.imageId;
      imageElement.remove();

      const files = Array.from(this.imagesUploadTarget.files).filter(
          (file) => file.name !== imageId
      );
      this.updateFileInput(files);
    }
  }

  // Update file input with remaining files
  updateFileInput(files) {
    const dataTransfer = new DataTransfer();
    files.forEach((file) => dataTransfer.items.add(file));
    this.imagesUploadTarget.files = dataTransfer.files;
  }
}
