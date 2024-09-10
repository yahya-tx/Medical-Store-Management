class CreateStockTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_transfers do |t|
      t.references :from_branch, null: false, foreign_key: { to_table: :branches }
      t.references :to_branch, null: false, foreign_key: { to_table: :branches }
      t.references :medicine, null: false, foreign_key: true
      t.integer :quantity
      t.integer :status
      t.references :requested_by, null: false, foreign_key: { to_table: :users }
      t.references :approved_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
