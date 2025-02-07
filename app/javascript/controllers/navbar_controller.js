import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['navbarMenu'];

  connect() {
    this.isNavBarOpen = false
    window.addEventListener('resize', this.handleResize.bind(this));
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize.bind(this));
    document.body.classList.remove('overflow-hidden', 'h-screen', 'fixed', 'w-full');
  }

  toggleNavBarMenu() {
    // this.navbarMenuTarget.classList.toggle("-translate-x-full");
    this.toggleBodyScroll();
    this.isNavBarOpen = !this.isNavBarOpen;
  }

  toggleBodyScroll() {
    if (document.body.classList.contains('overflow-hidden')) {
      document.body.classList.remove('overflow-hidden', 'h-screen', 'fixed', 'w-full');
    } else {
      document.body.classList.add('overflow-hidden', 'h-screen', 'fixed', 'w-full');
    }
  }

  handleResize() {
    if (window.innerWidth >= 768) {
      this.navbarMenuTarget.classList.remove('-translate-x-full');
    } else {
      this.navbarMenuTarget.classList.add('-translate-x-full');
    }
  }
}