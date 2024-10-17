require "rails_helper"

RSpec.describe Branch, type: :model do 
    let(:user) { User.create!(name: 'Test User', email: "requester@example.com", password: "password",phone_number: "0323-1231231") }

    it 'is valid with a name and a location' do 
        branch = Branch.new(name: "Shalamar Branch", location: "Main Street", user_id: user.id)
        expect(branch).to be_valid
    end
    it 'is not valid without a name' do 
        branch = Branch.new(name: "Shalamar Branch",location: nil)
        expect(branch).not_to be_valid
    end

    it 'is not valid without a location' do 
        branch = Branch.new(name: "Shalamar Branch")
        expect(branch).not_to be_valid
        expect(branch.errors[:location]).to include("can't be blank")
    end
end
