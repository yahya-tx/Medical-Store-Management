document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("add-medicine").addEventListener("click", function(e) {
    e.preventDefault();

    const medicinesFields = document.getElementById("medicines-fields");
    const newField = `
      <div class="medicine-form-group">
        <label>Enter Medicine Name</label>
        <input type="text" name="stock_transfer[medicine_name][]" class="medicine-form-control" placeholder="Enter the medicine name">
      </div>
      <div class="medicine-form-group">
        <label>Enter Quantity</label>
        <input type="number" name="stock_transfer[quantity][]" class="medicine-form-control" placeholder="Enter quantity">
      </div>
    `;
    medicinesFields.insertAdjacentHTML('beforeend', newField);
  });
});