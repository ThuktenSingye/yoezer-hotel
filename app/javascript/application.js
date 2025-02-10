// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';
import { Application } from '@hotwired/stimulus';
import Flatpickr from 'stimulus-flatpickr';
import AOS from 'aos';
import Dialog from '@stimulus-components/dialog'

const application = Application.start();
application.register('flatpickr', Flatpickr);
application.register('dialog', Dialog)

document.addEventListener("turbo:load", () => {
  AOS.init();
});

function handleViewTransition(event) {
  if (document.startViewTransition) {
    const originalRender = event.detail.render;

    event.detail.render = (currentElement, newElement) => {
      document.startViewTransition(() =>
        originalRender(currentElement, newElement),
      );
    };
  }
}

document.addEventListener('turbo:before-frame-render', handleViewTransition);
document.addEventListener('turbo:before-stream-render', handleViewTransition);

const events = [
  "turbo:fetch-request-error",
  "turbo:frame-missing",
  "turbo:frame-load",
  "turbo:frame-render",
  "turbo:before-frame-render",
  "turbo:load",
  "turbo:render",
  "turbo:before-stream-render",
  "turbo:before-render",
  "turbo:before-cache",
  "turbo:submit-end",
  "turbo:before-fetch-response",
  "turbo:before-fetch-request",
  "turbo:submit-start",
  "turbo:visit",
  "turbo:before-visit",
  "turbo:click"
];

events.forEach(e => {
  addEventListener(e, () => {
    console.log(e);
  });
});
