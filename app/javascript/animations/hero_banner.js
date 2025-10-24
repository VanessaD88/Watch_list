document.addEventListener("DOMContentLoaded", () => {
  const banner = document.querySelector(".banner-img");
  const container = document.querySelector(".hero_banner-container");

  if (banner) {
    setTimeout(() => banner.classList.add("zoomed"), 200);
  }

  if (container) {
    setTimeout(() => container.classList.add("visible"), 500);
  }
});
