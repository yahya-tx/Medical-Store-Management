class V1::RecordsController < ApplicationController
  before_action :set_branch , only: [:index, :new, :show, :update, :destroy, :edit,:create,:dispatch_order,:pending_orders,:delivered_orders]
  before_action :set_record, only: [:show, :update, :destroy, :edit]

  
  def index
    today = 90.days.ago
    @per_page = params[:per_page]
    
    # Fetch records based on user role
    if current_user.cashier?
      @records = @branch.records.where(created_at: today.beginning_of_day..Time.now, cashier_id: current_user.id).page(params[:page]).per(@per_page)
    elsif current_user.super_admin? && params[:branch_id]
      @branch = Branch.find(params[:branch_id])
      @records = @branch.records.where(created_at: today.beginning_of_day..Time.now).where.not('cashier_id = customer_id').page(params[:page]).per(@per_page)
    else
      @records = @branch.records.where(created_at: today.beginning_of_day..Time.now).where.not('cashier_id = customer_id').page(params[:page]).per(@per_page)
    end
    
    @total_sales = @records.sum(:total_amount)
  end

  def pending_orders
    @per_page = params[:per_page]
    @pending_orders = @branch.records.where(tracking_id: nil).where('cashier_id = customer_id').order(created_at: :desc).page(params[:page]).per(@per_page)
  end
  
  def delivered_orders
    @per_page = params[:per_page]
    @delivered_orders = @branch.records.where.not(tracking_id: nil).order(created_at: :desc).page(params[:page]).per(@per_page)
  end

  def customer_records
    @per_page = params[:per_page]
    @records = Record.where(customer_id: current_user.id)
    @pending_orders = @records.where(tracking_id: nil).order(created_at: :desc).page(params[:page]).per(@per_page)
    @delivered_orders = @records.where.not(tracking_id: nil).order(created_at: :desc).page(params[:page]).per(@per_page)
  end
  def get_medicines_for_branch
    branch_id = params[:branch_id]
    medicines = Medicine.where(branch_id: branch_id)
    render json: medicines.to_json(only: [:name, :quantity])
  end
  
  def show
  end

  def dispatch_order
    order = Record.find_by(id: params[:id])
    user_id = order.customer_id
    tracking_number = SecureRandom.alphanumeric(5).upcase
    order.update(tracking_id: tracking_number)
    message = "Your order is dispatched. You Will recieve your order in next 2 to 3 working days. Your order tracking ID is #{order.tracking_id}"
    DispatchOrderNotificationJob.perform_later(user_id,message)
    if order.tracking_id.present?
      flash[:notice] = 'Order Dispatched successfully'
      redirect_to v1_branch_records_path(@branch)
    end
  end
  def new
    if current_user.cashier? || current_user.customer?
      @record = @branch.records.new
    else
      flash[:alert] = "You are not authorized to perform this action"
      redirect_to v1_root_path
    end
  end
  def new_purchase
    @record = Record.new
  end


  def customer_purchase
    @record = Record.new
    medicine_names = params[:record][:medicine_name]
    tablet_counts = params[:record][:number_of_tablets]
    @record.branch_id = params[:record][:branch_id]
  
    total_amount = 0
    medicines_to_process = [] 
  
    medicine_names.each_with_index do |name, index|
      medicine = Medicine.find_by('lower(name) = ?', name.downcase)
      if medicine.present?
        tablet_number = tablet_counts[index].to_i
        if tablet_number > medicine.quantity
          flash[:alert] = "Not enough stock for #{medicine.name}"
        else
          total_amount += medicine.price * tablet_number
          new_quantity = medicine.quantity - tablet_number
          medicine.update(quantity: new_quantity)
  
          medicines_to_process << { 
            medicine_id: medicine.id, 
            name: medicine.name, 
            code: medicine.product_code, 
            number_of_tablets: tablet_number 
          }
        end
      else
        flash[:alert] = "Medicine #{name} not found" 
      end
    end
  
    if medicines_to_process.empty?
      flash[:alert] = 'No valid medicines to process. Please check your selections or Enter Valid Quantity'
      redirect_to v1_root_path and return
    end
  
    @record.medicine_ids = medicines_to_process
  
    customer = current_user
    @record.customer_id = customer.id if customer.present?
    @record.cashier_id = current_user.id
    @record.payment_method = params[:record][:payment_method]
    @record.total_amount = total_amount
    @record.address = params[:record][:address]
    @record.postal_code = params[:record][:postal_code]
  
    if params[:record][:payment_method] == 'online'
      stripe_email = params[:record][:stripe_email]
      token = params[:record][:stripe_token]
      begin
        intent = payment_intent(stripe_email, total_amount, token)
      rescue Stripe::CardError => e
        flash[:alert] = "Payment failed: #{e.message}"
        redirect_to v1_root_path and return
      end
    end
  
    if @record.save
      SendEmailNotificationJob.perform_later(@record, current_user)
      user_ids = User.where(branch_id: @record.branch_id).where.not(role: "customer").pluck(:id)
    
      order_id = @record.id
      message = "A new Order is received from customer name #{current_user.name} and contact no is #{current_user.phone_number}"
      
      # Pass the user IDs instead of the ActiveRecord relation
      OrderNotificationJob.perform_later(user_ids, message, order_id)
      flash[:notice] = 'Your order has been placed successfully; you will receive an email shortly!'
      redirect_to v1_root_path
    else
      flash[:alert] = 'Error while creating the bill'
      redirect_to v1_root_path
    end
  end
  

  def create
    @record = @branch.records.new
    
    medicine_names = params[:record][:medicine_name]
    tablet_counts = params[:record][:number_of_tablets]
  
    if medicine_names.size == tablet_counts.size
      total_amount = 0

      medicine_names.each_with_index do |name, index|
        medicine = Medicine.find_by('lower(name) = ?', name.downcase)
        if medicine.present?
          tablet_number = tablet_counts[index].to_i
          new_quantity = medicine.quantity - tablet_number
          if new_quantity < 0
            flash[:alert] = "Not enough stock for #{medicine.name}"
            render :new and return
          end

          total_amount += medicine.price * tablet_number

          medicine.update(quantity: new_quantity)

          @record.medicine_ids << { medicine_id: medicine.id, name: medicine.name, code: medicine.product_code, number_of_tablets: tablet_number }
        else
          flash[:alert] = "Medicine #{name} not found"
          render :new and return
        end
      end

      customer = User.find_by(phone_number: params[:record][:customer_contact], role: 'customer')
      # if !customer.present?
      #   customer = User.create(phone_number: params[:customer_contact], role: 'customer', password: "123456")
      # end
      @record.customer_id = customer.id if customer.present?
      @record.cashier_id = current_user.id
      @record.payment_method = params[:record][:payment_method]
      @record.customer_contact = params[:record][:customer_contact]
      @record.total_amount = total_amount
      if params[:record][:payment_method] == 'online'
        stripe_email = params[:record][:stripe_email]
        token = params[:record][:stripe_token]
        begin
          intent = payment_intent(stripe_email, total_amount, token)
        rescue Stripe::CardError => e
          flash[:alert] = "Payment failed: #{e.message}"
          render :new and return
        end
      end
      if @record.save
        if current_user.cashier?
          create_audit
        end
        SendEmailNotificationJob.perform_later(@record, current_user)
        flash[:notice] = 'Record created successfully'
        redirect_to v1_branch_record_path(@branch, @record)
      else
        flash[:alert] = 'Error While Creating Bill'
        redirect_to v1_branch_records_path(@branch)
      end
    else
      flash[:alert] = 'Mismatched medicine names and tablet counts'
      render :new
    end
  end

  def edit
  end

  def update
    # medicine_names = params[:record][:medicine_name]
    # tablet_counts = params[:record][:number_of_tablets]

    # if medicine_names.size == tablet_counts.size
    #   total_amount = 0
    #   new_medicines = []

    #   medicine_names.each_with_index do |name, index|
    #     medicine = Medicine.find_by('lower(name) = ?', name.downcase)

    #     if medicine.present?
    #       tablet_number = tablet_counts[index].to_i
    #       new_quantity = medicine.quantity - tablet_number

    #       if new_quantity < 0
    #         flash[:alert] = "Not enough stock for #{medicine.name}"
    #         render :edit and return
    #       end

    #       total_amount += medicine.price * tablet_number

    #       medicine.update(quantity: new_quantity)

    #       new_medicines << { medicine_id: medicine.id, name: medicine.name, code: medicine.product_code, number_of_tablets: tablet_number }
    #     else
    #       flash[:alert] = "Medicine #{name} not found"
    #       render :edit and return
    #     end
    #   end

    #   @record.update(medicine_ids: new_medicines, total_amount: total_amount)

    #   if @record.update(record_params.merge(total_amount: total_amount))
    #     flash[:notice] = 'Record updated successfully'
    #     redirect_to branch_record_path(@branch, @record)
    #   else
    #     render :edit
    #   end
    # else
    #   flash[:alert] = 'Mismatched medicine names and tablet counts'
    #   render :edit
    # end
  end

  def destroy
    @record.medicine_ids.each do |med|
      medicine = Medicine.find_by('lower(name) = ?', med['name'].downcase)
      old_quantity = med['number_of_tablets']
      new_quantity = medicine.quantity + old_quantity
      medicine.update(quantity: new_quantity)
    end

    if @record.destroy
      flash[:notice] = "Record deleted successfully."
      redirect_to v1_branch_records_path(@branch)
    else
      flash[:alert] = "Record could not be deleted."
      redirect_to v1_branches_path
    end
  end

  private

  def set_branch
    @branch = Branch.find(params[:branch_id])
  end

  def set_record
    @record = @branch.records.find(params[:id])
  end

  def record_params
    params.require(:record).permit(:payment_method, :customer_contact, :stripe_email,:address,:postal_code)
  end

  def payment_intent(stripe_email, total_amount, token)
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
  
    payment_method = Stripe::PaymentMethod.create({
      type: 'card',
      card: { token: token },
    })
  
    intent = Stripe::PaymentIntent.create({
      amount: (total_amount * 100).to_i,
      currency: 'usd',
      payment_method: payment_method.id,
      receipt_email: stripe_email,
      confirm: true,
      automatic_payment_methods: {
        enabled: true,
        allow_redirects: "never"
      },
      description: 'Medicine purchase',
    })
  
    intent
  end
  
  


  def create_audit
    from = 90.days.ago.beginning_of_day
    to = Time.current.end_of_day
    records = Record.where(created_at: from..to, cashier_id: current_user.id)
    total_records = records.count
    total_amount = records.sum(:total_amount)
    total_medicines_sold = records.sum { |record| record.medicine_ids.sum { |medicine| medicine["number_of_tablets"] } }
    medicine_details = []
    records.each do |record|
      record.medicine_ids.each do |medicine|
        medicine_name = medicine["name"]
        medicine_quantity = medicine["number_of_tablets"]

        existing_entry = medicine_details.find { |med| med[:name] == medicine_name }
        if existing_entry
          existing_entry[:quantity] += medicine_quantity
        else
          medicine_details << { name: medicine_name, quantity: medicine_quantity }
        end
      end
    end
    audit = AuditLog.find_by(user_id: current_user.id)
    if audit.present?
      audit.update(
        total_records_count: total_records,
        total_amount: total_amount,
        total_medicines_sold: total_medicines_sold,
        medicine_details: medicine_details,
        audited_to: to,
        audited_from: from
      )
    else
      new_audit = @branch.audit_logs.new(
      audited_from: from,
      audited_to: to,
      total_records_count: total_records,
      total_amount: total_amount,
      total_medicines_sold: total_medicines_sold,
      user_id: current_user.id,
      medicine_details: medicine_details,
      branch_id: @branch.id,
      description: current_user.name
    )
    new_audit.save
    end
  end
end
