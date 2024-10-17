class V1::RefundsController < ApplicationController
    before_action :set_refund, only: [:show, :destroy, :approve]

    def index
        @per_page = params[:per_page] || 5
        
        if current_user.branch_admin?
            @refunds = Refund.where(branch_admin_id: current_user.id).page(params[:page]).per(@per_page)
        else
            @refunds = Refund.where(customer_id: current_user.id).page(params[:page]).per(@per_page)
        end
    end
      

    def new 
       @refund = Refund.new
       @record_id = params[:record_id]
    end

    def create
        @record = Record.find_by(id: params[:refund][:record_id])

        if @record.present?
            order = @record
            customer_id = order.customer_id
            branch_admin = User.branch_admin.where(branch_id: order.branch_id).first
            branch_id = order.branch_id
            medicine_details = order.medicine_ids
            record_id = @record.id
            @refund = Refund.new(
                customer_id: customer_id,
                branch_id: branch_id,
                branch_admin_id: branch_admin.id,
                reason: params[:refund][:reason], 
                medicine_details: medicine_details,
                record_id: record_id,
                status: "pending"
            )
            if @refund.save
                message = "New Refund Request For order_id#{order.id} is recieved"
                RefundNotificationJob.perform_later(branch_admin.id,message,record_id)
                flash[:notice] = 'Refund created successfully'
                if !current_user.customer?
                  redirect_to v1_refunds_path
                else
                    redirect_to customer_records_v1_records_path
                end
            else
                flash[:alert] = 'Error creating refund'
                render :new
            end
        else
            flash[:alert] = 'No record found'
            render :new
        end
    end

    def destroy
        if @refund.present?
          customer_id = @refund.customer_id
          order_id = @refund.record_id
          if @refund.destroy
            DenyRefundNotificationJob.perform_later(customer_id, order_id)
            flash[:notice] = 'Refund Destroyed successfully'
            redirect_to v1_refunds_path
          else
            flash[:alert] = 'Refund not Found'
            redirect_to v1_refunds_path
          end
        else
           flash[:alert] = 'Refund not Found'
           redirect_to v1_refunds_path
        end
    end

    def approve
        if @refund.present?
            record = Record.find_by(id: @refund.record_id)
            if record.payment_method == 'online' && record.payment_intent_id.present?
                begin
                  refund_online_payment(record.payment_intent_id)
                rescue Stripe::InvalidRequestError => e
                  flash[:alert] = "Refund failed: #{e.message}"
                  redirect_to v1_refunds_path and return
                end
            end
            @refund.medicine_details.each do |med|
                medicine = Medicine.find_by('lower(name) = ? AND branch_id = ?', med['name'].downcase, @refund.branch_id)
                old_quantity = medicine.quantity
                refund_quantity =  med['number_of_tablets']
                medicine.update(quantity: (old_quantity + refund_quantity))
                @refund.update(status: "approved")       
            end
            flash[:notice] = "Refund Request Approved..Customer will be notified shortly"
            customer_id = @refund.customer_id
            order_id = @refund.record_id
            ApproveRefundNotificationJob.perform_later(customer_id, order_id)
            redirect_to v1_refunds_path
        else
            flash[:alert]= "Refund Order Not Found"
            redirect_to v1_refunds_path
        end
    end
      
      
    private

    
    def set_refund
        @refund = Refund.find_by(id: params[:id])
    end

    def refund_online_payment(payment_intent_id)
        Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
      
        Stripe::Refund.create({
          payment_intent: payment_intent_id,
        })
    end

end
