class AddBranchIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :branch_id, :integer, null: true
    add_foreign_key :users, :branches
  end
end
