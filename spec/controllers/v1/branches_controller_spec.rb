require 'rails_helper'

RSpec.describe V1::BranchesController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  let!(:user) { User.create!(name: 'Test User', email: "requester@example.com", password: "password", phone_number: "0323-1231231") }
  let!(:existing_branch1) { Branch.create!(name: 'Shama Branch', location: 'Shama Lahore', user_id: user.id) }
  let!(:existing_branch2) { Branch.create!(name: 'Model Town Branch', location: 'Model Town Lahore', user_id: user.id) }
  let!(:other_branch) { Branch.create!(name: 'MyString', location: 'MyString', user_id: user.id) }
    
  before do
    sign_in user
  end
  
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  
    it 'fetches all branches' do
      get :index
      # Debugging: Print the assigned branches
      puts "Assigned branches: #{assigns(:branches).inspect}"

      expect(assigns(:branches)).to match_array([existing_branch1, existing_branch2, other_branch])
    end
  end
end
