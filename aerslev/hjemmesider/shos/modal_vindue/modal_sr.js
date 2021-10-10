// Get the modal
var modalSr = document.getElementById("modalSr");

// Get the button that opens the modal
var btnSr = document.getElementById("btnSr");

// Get the <span> element that closes the modal
var spanSr = document.getElementsByClassName("closeSr")[0];

// When the user clicks the button, open the modal 
btnSr.onclick = function() {
  modalSr.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
spanSr.onclick = function() {
  modalSr.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalSr) {
    modalSr.style.display = "none";
  }
}