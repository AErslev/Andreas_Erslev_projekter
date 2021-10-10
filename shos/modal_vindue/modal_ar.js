// Get the modal
var modalAr = document.getElementById("modalAr");

// Get the button that opens the modal
var btnAr = document.getElementById("btnAr");

// Get the <span> element that closes the modal
var spanAr = document.getElementsByClassName("closeAr")[0];

// When the user clicks the button, open the modal 
btnAr.onclick = function() {
  modalAr.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
spanAr.onclick = function() {
  modalAr.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalAr) {
    modalAr.style.display = "none";
  }
}