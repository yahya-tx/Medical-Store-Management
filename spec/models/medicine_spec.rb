require 'rails_helper'

RSpec.describe Medicine, type: :model do
  let(:branch) { Branch.create(name: 'Main Branch') } # Create a branch instance

  it 'is not valid without a name' do
    medicine = Medicine.new(name: nil, branch: branch)
    expect(medicine).to_not be_valid
  end

  it 'is not valid without a price' do
    medicine = Medicine.new(price: nil, branch: branch)
    expect(medicine).to_not be_valid
  end

  it 'is valid with valid attributes' do
    medicine = Medicine.new(name: 'Aspirin', branch: branch)
    expect(medicine).to be_valid
  end
end
