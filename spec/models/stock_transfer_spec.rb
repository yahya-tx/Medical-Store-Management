require 'rails_helper'

RSpec.describe StockTransfer, type: :model do
  let(:requested_by) { User.create!(name: "Requester", email: "requester@example.com", password: "password",phone_number: "0323-1231231") }
  let(:approved_by) { User.create!(name: "Approver", email: "approver@example.com", password: "password",phone_number: "0323-1231239") }
  let(:branch) { Branch.create!(name: "Main Branch",location: "DownTown",user_id: requested_by.id) }  # You need to provide valid attributes for your branch
  let(:to_branch) { Branch.create!(name: "Secondary Branch",location: "DownTown",user_id: requested_by.id) }  # You can do this for to_branch as well

    let(:valid_stock_transfer_attributes) do
        {
            branch: branch,
            to_branch: to_branch,
            quantity: 10,
            status: :pending,
            requested_by: requested_by,
            approved_by: approved_by,
            medicine_ids: [{"code"=>"M2945893", "name"=>"Panadol", "quantity"=>10, "medicine_id"=>11}]
        }  
    end

    it "is valid with valid attributes" do
      stock_transfer = StockTransfer.new(valid_stock_transfer_attributes)

      expect(stock_transfer).to be_valid
    end

    it "is not valid without requested by a user" do 
        stock_transfer = StockTransfer.new(valid_stock_transfer_attributes.merge(requested_by: nil))
        expect(stock_transfer).not_to be_valid
    end

    it "is not valid without a user to approve the stock transfer" do
        stock_transfer = StockTransfer.new(valid_stock_transfer_attributes.merge(approved_by: nil))
        expect(stock_transfer).not_to be_valid
    end

    it "is not valid without a quantity" do 
        stock_transfer = StockTransfer.new(valid_stock_transfer_attributes.merge(quantity: nil))
        expect(stock_transfer).not_to be_valid
    end
end
