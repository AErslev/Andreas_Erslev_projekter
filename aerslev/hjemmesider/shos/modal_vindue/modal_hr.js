// Get the modal
var modalHr = document.getElementById("modalHr");

// Get the button that opens the modal
var btnHr = document.getElementById("btnHr");

// Get the <span> element that closes the modal
var spanHr = document.getElementsByClassName("closeHr")[0];

// When the user clicks the button, open the modal 
btnHr.onclick = function() {
  modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
spanHr.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalHr) {
    modal.style.display = "none";
  }
}