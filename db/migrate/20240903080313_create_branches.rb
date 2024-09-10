class CreateBranches < ActiveRecord::Migration[7.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :location
      t.jsonb :stock, default: {}

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
