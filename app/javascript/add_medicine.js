document.addEventListener("DOMContentLoaded", function() {
  const addMedicineButton = document.getElementById("add-medicine");
  const medicinesFields = document.getElementById("medicines-fields");

  const medicinesData = JSON.parse(document.getElementById("medicine-data").getAttribute("data-medicines"));

  addMedicineButton.addEventListener("click", function(e) {
    e.preventDefault();

    const selectElement = document.querySelector("select[name='record[medicine_name][]']");

    if (!selectElement) {
      console.error("Original medicine select element not found.");
      return;
    }

    const optionsHTML = selectElement.innerHTML;

    const newField = `
      <div class="medicine-form-group">
        <label>Select Medicine</label>
        <select name="record[medicine_name][]" class="medicine-form-control select-medicine">
          ${optionsHTML}
        </select>
      </div>
      <br>
      <div class="medicine-form-group">
        <input type="number" name="record[number_of_tablets][]" class="medicine-form-control" placeholder="Enter number of tablets">
        <div class="available-quantity" style="margin-top: 5px; font-weight: bold;"></div>
      </div>
    `;

    medicinesFields.insertAdjacentHTML('beforeend', newField);

    $('.select-medicine').select2({
      placeholder: 'Search for a medicine',
      allowClear: true
    });

    // Attach quantity check to the new quantity input
    const quantityInputs = medicinesFields.querySelectorAll("input[name='record[number_of_tablets][]']");
    const medicineSelects = medicinesFields.querySelectorAll("select[name='record[medicine_name][]']");

    quantityInputs[quantityInputs.length - 1].addEventListener('input', function() {
      checkAvailableQuantity(medicineSelects[medicineSelects.length - 1], quantityInputs[quantityInputs.length - 1]);
    });
    medicineSelects[medicineSelects.length - 1].addEventListener('change', function() {
      checkAvailableQuantity(medicineSelects[medicineSelects.length - 1], quantityInputs[quantityInputs.length - 1]);
    });
  });

  function checkAvailableQuantity(selectElement, quantityInput) {
    const selectedMedicine = selectElement.value;
    const medicine = medicinesData.find(m => m.name === selectedMedicine);

    const availableQuantityDisplay = quantityInput.nextElementSibling; // Assuming the next element is the available quantity display

    if (medicine) {
      const availableQuantity = medicine.quantity;
      availableQuantityDisplay.textContent = `Available: ${availableQuantity}`;

      const enteredQuantity = parseInt(quantityInput.value) || 0;

      if (enteredQuantity > availableQuantity) {
        addMedicineButton.hidden = true; 
        window.alert("Please select a valid quantity that is less than or equal to the available stock.");
      } else {
        addMedicineButton.hidden = false; 
      }
    } else {
      availableQuantityDisplay.textContent = ''; 
      addMedicineButton.hidden = true; 
    }
  }
});
