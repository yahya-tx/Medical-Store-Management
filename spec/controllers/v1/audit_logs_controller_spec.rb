require 'rails_helper'

RSpec.describe V1::AuditLogsController, type: :controller do
    include Devise::Test::ControllerHelpers

    let!(:branch) { create(:branch) } 
    let!(:user) { create(:user) }
    let!(:audit_log1) { create(:audit_log, branch: branch, user: user) }
    let!(:audit_log2) { create(:audit_log, branch: branch, user: user) }
    let!(:audit_log3) { create(:audit_log, branch: branch, user: user) }

  describe 'GET #index' do
    before do
      sign_in user 
      get :index, params: { branch_id: branch.id }
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'paginates audit logs' do
      expect(assigns(:audit_logs).count).to eq(2)
    end
  end

    describe 'GET #new' do
        before do
            sign_in user
            get :new, params: { branch_id: branch.id }
        end

        it 'assigns a new audit log to @audit_log' do
            expect(assigns(:audit_log)).to be_a_new(AuditLog)
        end

        it 'associates the new audit log with the correct branch' do
            expect(assigns(:audit_log).branch_id).to eq(branch.id)
        end

        it 'renders the new template' do
            expect(response).to render_template(:new)
        end
    end

    describe 'GEt #show' do
        before do
            sign_in user
            get :show, params: { branch_id: branch.id ,id: audit_log1.id}
        end

        it "renders a audit log of a specific user" do
          expect(response).to render_template(:show)
        end

        it 'assigns the requested audit_log to @audit_log' do
            expect(assigns(:audit_log)).to eq(audit_log1)
        end
    end

    describe 'DELETE #destroy' do
        before do
            sign_in user
        end
        it 'deletes the audit log' do
            expect {
              delete :destroy, params: { branch_id: branch.id, id: audit_log1.id }
            }.to change(AuditLog, :count).by(-1)
        end
    
    end
end
