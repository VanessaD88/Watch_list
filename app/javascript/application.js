// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", () => {
  const banner = document.querySelector(".banner img");
  if (banner) {
    setTimeout(() => {
      banner.classList.add("zoomed");
    }, 200); // start zoom shortly after page loads
  }
});
