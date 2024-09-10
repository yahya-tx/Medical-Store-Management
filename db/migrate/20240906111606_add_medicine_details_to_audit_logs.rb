class AddMedicineDetailsToAuditLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :audit_logs, :medicine_details, :jsonb, default: {}
  end
end
