document.addEventListener('DOMContentLoaded', function () {
    var input = document.querySelector("#user_phone_number");
  
    if (input) { 
      var iti = window.intlTelInput(input, {
        initialCountry: "auto",
        geoIpLookup: function (callback) {
          fetch('https://ipinfo.io/json')
            .then(response => response.json())
            .then(data => callback(data.country))
            .catch(() => callback("us"));
        },
        utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js"
      });
  
      var form = document.querySelector('form.devise-form');
      form.addEventListener('submit', function () {
        var countryCode = iti.getSelectedCountryData().dialCode;
        var phoneNumber = input.value.trim();
        input.value = `+${countryCode}${phoneNumber}`;
      });
    }
  });
  