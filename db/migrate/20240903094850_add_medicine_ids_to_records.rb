class AddMedicineIdsToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :medicine_ids, :jsonb, default: []
    add_column :stock_transfers, :medicine_ids, :jsonb, default: []
    add_column :medicines, :product_code, :string
  end
end
