require "rails_helper"

RSpec.describe Record, type: :model do
  let(:cashier) { User.create!(name: "Cashier", role: "cashier", email: "cashier123@gmail.com", phone_number: "0323-12121212", password: "123456") }
  let(:branch_user) { User.create!(name: "Branch Owner", role: "cashier", email: "owner123@gmail.com", phone_number: "0323-12122312", password: "123456") }
  let(:branch) { Branch.create!(name: "Main Branch", location: "Downtown", user_id: branch_user.id) }
  let(:medicine) { Medicine.create(name: "Dispreine", product_code: "S49f9b49", branch_id: branch.id) }

  let(:valid_record_attributes) do
    {
      cashier_id: cashier.id,
      total_amount: 5.0,
      payment_method: "cash",
      customer_contact: "+920303-73477433",
      medicine_ids: [{"code" => "S49f9b49", "name" => "Dispreine", "medicine_id" => medicine.id, "number_of_tablets" => 1}],
      branch_id: branch.id
    }
  end

  it 'is valid with valid attributes' do
    record = Record.new(valid_record_attributes)
    expect(record).to be_valid
  end

  it "is not valid without cashier_id" do
    record = Record.new(valid_record_attributes.merge(cashier_id: nil))
    expect(record).not_to be_valid
  end
end
