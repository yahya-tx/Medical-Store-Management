class AddBranchIdToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :branch_id, :integer
  end
end
