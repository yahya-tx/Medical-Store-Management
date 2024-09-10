class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.references :cashier, null: false, foreign_key: { to_table: :users }
      t.decimal :total_amount
      t.integer :payment_method
      t.integer :status
      t.references :medicine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
