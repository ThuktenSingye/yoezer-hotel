  import { Controller } from '@hotwired/stimulus'
  import { toggle} from 'el-transition';
  // Connects to data-controller='dropdown'

  export default class extends Controller {

    static  targets = ['roomMenu', 'hotelMenu','sidebar', 'backdrop', 'sidebar_toggle']

    toggleRoomMenu(){
      toggle(this.roomMenuTarget)
    }

    toggleHotelMenu(){
      toggle(this.hotelMenuTarget)
    }

    toggleSidebar(event) {
      this.sidebar_toggleTarget.classList.toggle('hidden')
      this.sidebarTarget.classList.toggle('-translate-x-full');
      this.backdropTarget.classList.toggle('hidden')
    }

  }
