document.addEventListener('turbo:load', function() {
    var stripePublicKey = document.getElementById('stripe-public-key').getAttribute('data-key');
    var stripe = Stripe(stripePublicKey);
    var elements = stripe.elements();
    var cardElement = elements.create('card');
    cardElement.mount('#stripe-card-element');
  
    document.getElementById('stripe-submit-button').addEventListener('click', function(event) {
      event.preventDefault();
  
      var paymentMethod = document.getElementById('payment-method-select').value;
      if (paymentMethod === 'online') {
        stripe.createToken(cardElement).then(function(result) {
          if (result.error) {
            alert(result.error.message);
          } else {
            document.querySelector('input[name="record[stripe_token]"]').value = result.token.id;
            document.getElementById('medicine-form').submit(); 
          }
        });
      } else {
        document.getElementById('medicine-form').submit(); 
      }
    });
  
    const paymentMethodSelect = document.getElementById('payment-method-select');
    const onlinePaymentFields = document.getElementById('online-payment-fields');
  
    paymentMethodSelect.addEventListener('change', function() {
      if (this.value === 'online') {
        onlinePaymentFields.style.display = 'block';
      } else {
        onlinePaymentFields.style.display = 'none';
      }
    });
  });
  