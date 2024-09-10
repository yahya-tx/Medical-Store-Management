class RemoveFromBranchIdFromStockTransfers < ActiveRecord::Migration[7.1]
  def change
    remove_column :stock_transfers, :from_branch_id, :integer
  end
end
