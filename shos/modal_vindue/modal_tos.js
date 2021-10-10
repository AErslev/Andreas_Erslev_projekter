// Get the modal
var modalToS = document.getElementById("modalToS");

// Get the button that opens the modal
var btnToS = document.getElementById("btnToS");

// Get the <span> element that closes the modal
var spanToS = document.getElementsByClassName("closeToS")[0];

// When the user clicks the button, open the modal 
btnToS.onclick = function() {
  modalToS.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
spanToS.onclick = function() {
  modalToS.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalToS) {
    modalToS.style.display = "none";
  }
}