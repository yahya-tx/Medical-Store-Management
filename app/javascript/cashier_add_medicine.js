document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("add-medicine").addEventListener("click", function(e) {
      e.preventDefault();
  
      const medicinesFields = document.getElementById("medicines-fields");
      const selectElement = document.querySelector("select[name='record[medicine_name][]']");
  
      if (!selectElement) {
        console.error("Original medicine select element not found.");
        return;
      }
  
      const optionsHTML = selectElement.innerHTML;
  
      // Use backticks for multi-line HTML string
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
        </div>
      `;
  
      medicinesFields.insertAdjacentHTML('beforeend', newField);
  
      // Reinitialize Select2 on the newly added select element
      $('.select-medicine').select2({
        placeholder: 'Search for a medicine',
        allowClear: true
      });
    });
});
