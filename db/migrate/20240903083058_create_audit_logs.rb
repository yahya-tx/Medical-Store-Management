class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.integer :total_records_count
      t.decimal :total_amount
      t.integer :total_medicines_sold
      t.jsonb :summary_details
      t.datetime :audited_from
      t.datetime :audited_to

      t.timestamps
    end
  end
end
