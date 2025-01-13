// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function handleViewTransition(event) {
    if (document.startViewTransition) {
        const originalRender = event.detail.render;

        event.detail.render = (currentElement, newElement) => {
            document.startViewTransition(() => originalRender(currentElement, newElement));
        }
    }
}

document.addEventListener('turbo:before-frame-render', handleViewTransition);
document.addEventListener('turbo:before-stream-render', handleViewTransition);
