document.addEventListener('turbo:load', function() {
    const flashMessages = document.querySelectorAll(".flash");
  
    flashMessages.forEach(function(flashMessage) {
      setTimeout(function() {
        flashMessage.style.display = 'none';
      }, 3000);
    });
  });
  