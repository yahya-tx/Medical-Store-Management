class RemoveMedicineIdFromStockTransfers < ActiveRecord::Migration[7.1]
  def change
    remove_column :stock_transfers, :medicine_id, :integer
  end
end
