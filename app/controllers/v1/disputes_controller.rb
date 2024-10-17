class V1::DisputesController < ApplicationController
    before_action :set_dispute, only: [:show,:approve,:deny]
  
    def index
      @disputes = Dispute.all
    end
  
    def show
    end
  
    def new
      @dispute = Dispute.new
      @record_id = params[:record_id]
    end
  
    def create
      @record = Record.find_by(id: params[:dispute][:record_id])
      @dispute = Dispute.new(dispute_params)
      @dispute.branch_id = @record.branch_id
      @dispute.record_id = @record.id
      @dispute.customer_id = current_user.id
      @dispute.status = 'pending'
      if @dispute.save!
        flash[:notice] = 'Dispute was successfully created and notified to Stripe.'
        redirect_to v1_dispute_path(@dispute)
      else
        render :new
      end
    end

    def approve
        @dispute.update(status: 'approved')
        flash[:notice] = 'Dispute was successfully accepted'
        redirect_to v1_disputes_path
    end


    def deny
        @dispute.update(status: 'denied')
        flash[:notice] = 'Dispute was successfully denied'
        redirect_to v1_disputes_path
    end
    private
  
    def set_dispute
      @dispute = Dispute.find(params[:id])
    end
  
    def dispute_params
      params.require(:dispute).permit(:reason, :attachment,:record_id)
    end
  end
  