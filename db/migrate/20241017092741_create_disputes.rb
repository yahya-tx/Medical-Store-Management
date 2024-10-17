class CreateDisputes < ActiveRecord::Migration[7.1]
  def change
    create_table :disputes do |t|
      t.text :reason
      t.references :customer,null: true, foreign_key: { to_table: :users }
      t.integer :status
      t.references :branch, foreign_key: true
      t.references :record, foreign_key: true

      t.timestamps
    end
  end
end
