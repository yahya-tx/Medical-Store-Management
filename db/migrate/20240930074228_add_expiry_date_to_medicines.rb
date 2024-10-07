class AddExpiryDateToMedicines < ActiveRecord::Migration[7.1]
  def change
    add_column :medicines, :expiry_date, :date
    add_column :medicines, :expired, :boolean, default: false
  end
end
