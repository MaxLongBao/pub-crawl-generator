const initLoader = () => {
  // find button
  const button = document.querySelector(".submit");
  // find both divs on the new page
  const loader = document.querySelector(".loader");
  const navbar = document.querySelector(".navbar");
  const banner = document.querySelector(".banner");

  // add event listener to button
  if (button) {
    button.addEventListener("click", () => {
    navbar.classList.add("d-none");
    banner.classList.add("d-none");
    loader.classList.remove("d-none");
    });
  }
};


export { initLoader };
