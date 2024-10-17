require "rails_helper"

RSpec.describe AuditLog, type: :model do
    let(:user) { User.create!(name: "Requester", email: "requester@example.com", password: "password",phone_number: "0323-1231231") }
    let(:valid_audit_log_attributes) do
       {
          user_id: user.id,
          total_records_count: 34,
          total_amount: 2245.00,
          total_medicines_sold: 95,
          audited_from: Date.new(2024, 7, 12),
          audited_to: Date.new(2024, 10, 10),
          branch_id: 1,
          description: "Zainab",
          medicine_details: [
            {"name" => "Brufin", "quantity" => 13},
            {"name" => "Risek", "quantity" => 13}
           ]
        }
    end
    it "is valid with valid attributes" do
        audit_log = AuditLog.new(valid_audit_log_attributes)
        expect(audit_log).to be_valid
    end

    it "is not valid without user id in Audit Log" do
        audit_log = AuditLog.new(valid_audit_log_attributes.merge(user_id: nil))
        expect(audit_log).not_to be_valid
    end
end