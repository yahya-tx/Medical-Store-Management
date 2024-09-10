class AddBranchIdToStockTransfers < ActiveRecord::Migration[7.1]
  def change
    add_column :stock_transfers, :branch_id, :integer
  end
end
