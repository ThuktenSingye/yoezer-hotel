import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file"
export default class extends Controller {
  static targets = ["filesContainer", "fileInput", "existingFileContainer"];

  selectFile() {
    this.fileInputTarget.click();
  }

  addFile(event) {
    event.preventDefault();
    const files = Array.from(this.fileInputTarget.files);

    files.forEach((file) => {
      const reader = new FileReader();
      reader.onload = () => {
        const newFile = `
          <div data-file-target="existingFileContainer" data-file-id="${file.name}" class="border-b w-3/4">
            <div class="p-1 flex gap-1 items-center ">
              <i class="fa-solid fa-file text-primary-regular w-6 h-6 flex items-center justify-center"></i>
              <p data-file-target="filePreview" class="w-5/6">${file.name}</p>
              <div class="flex items-center justify-center avatar-cropper icon hover:cursor-pointer z-10" 
              data-action="click->file#removeFile" data-file-id="${file.name}">
                <i class="fa-solid fa-trash text-error"></i>
              </div>
            </div>
          </div>
        `;
        this.filesContainerTarget.insertAdjacentHTML("beforeend", newFile);
      };
      reader.readAsDataURL(file);
    });
  }

  removeExistingFile(event) {
    event.currentTarget.closest('[data-file-target="existingFileContainer"]').remove();
  }

  removeFile(event) {
    event.preventDefault();
    const fileElement = event.currentTarget.closest('[data-file-target="existingFileContainer"]');
    if (fileElement) {
      const fileId = fileElement.dataset.fileId;
      fileElement.remove();

      const files = Array.from(this.fileInputTarget.files).filter(
          (file) => file.name !== fileId
      );
      this.updateFileInput(files);
    }
  }

  // Update file input with remaining files
  updateFileInput(files) {
    const dataTransfer = new DataTransfer();
    files.forEach((file) => dataTransfer.items.add(file));
    this.fileInputTarget.files = dataTransfer.files;
  }
}
