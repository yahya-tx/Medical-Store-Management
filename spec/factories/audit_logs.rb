FactoryBot.define do
    factory :audit_log do
      association :user
      branch # This assumes you have a branch factory
      total_records_count { 34 }
      total_amount { 2245 }
      total_medicines_sold { 95 }
      audited_from { "2024-07-12 00:00:00" }
      audited_to { "2024-10-10 23:59:59" }
      description { "Zainab" }
      medicine_details { [{ name: "Brufin", quantity: 13 }, { name: "Risek", quantity: 13 }, { name: "Panadol", quantity: 32 }] }
    end
end
  