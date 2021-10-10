// Get the modal
var modalGr = document.getElementById("modalGr");

// Get the button that opens the modal
var btnGr = document.getElementById("btnGr");

// Get the <span> element that closes the modal
var spanGr = document.getElementsByClassName("closeGr")[0];

// When the user clicks the button, open the modal 
btnGr.onclick = function() {
  modalGr.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
spanGr.onclick = function() {
  modalGr.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalGr) {
    modalGr.style.display = "none";
  }
}