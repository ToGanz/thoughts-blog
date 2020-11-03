const dropdown = () => {
  let dropbtn = document.querySelector(".dropbtn");

  dropbtn.addEventListener("click", function () {
    let dropdownContent = document.querySelector("#myDropdown");
    dropbtn.classList.toggle("btn-clicked");
    dropdownContent.classList.toggle("show");
  });

  // Close the dropdown menu if the user clicks outside of it
  window.onclick = function (event) {
    if (!event.target.matches(".dropbtn")) {
      let dropdownContent = document.getElementsByClassName("dropdown-content");
      for (let i = 0; i < dropdownContent.length; i++) {
        let openDropdown = dropdownContent[i];
        if (openDropdown.classList.contains("show")) {
          openDropdown.classList.remove("show");
        }
      }
    }
  };
};

export default dropdown;
