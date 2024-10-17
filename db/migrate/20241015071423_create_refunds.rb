class CreateRefunds < ActiveRecord::Migration[7.1]
  def change
    create_table :refunds do |t|
      t.integer :status
      t.text :reason
      t.jsonb :medicine_details
      t.references :customer, foreign_key: { to_table: :users }
      t.references :branch, foreign_key: true
      t.references :branch_admin, foreign_key: { to_table: :users }
      t.references :record, foreign_key: true
      
      t.timestamps
    end
  end
end
