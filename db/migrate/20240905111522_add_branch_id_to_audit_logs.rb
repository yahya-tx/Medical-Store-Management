class AddBranchIdToAuditLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :audit_logs, :branch_id, :integer
    remove_column :audit_logs, :action, :string
    remove_column :audit_logs, :summary_details, :jsonb
    add_column :audit_logs, :description, :text
  end
end
