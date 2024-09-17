class RecordsController < ApplicationController
  before_action :set_branch , only: [:index, :new, :show, :update, :destroy, :edit,:create]
  before_action :set_record, only: [:show, :update, :destroy, :edit]

  def index
    today = 7.days.ago
    if current_user.cashier?
      @records = @branch.records.where(created_at: today.beginning_of_day..Time.now, cashier_id: current_user.id)
    else
      @records = @branch.records.where(created_at: today.beginning_of_day..Time.now)
    end
    @total_sales = @records.sum(:total_amount)
  end

  def show
  end

  def new
    if current_user.cashier? 
      @record = @branch.records.new
    else
      flash[:alert] = "You are not authorized to perform this action"
      redirect_to root_path
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
          redirect_to new_branch_record_path(@branch) and return
        end
      end

      customer = User.find_by(phone_number: params[:record][:customer_contact], role: 'customer')
      # if !customer.present?
      #   customer = User.create(phone_number: params[:record][:customer_contact], role: 'customer', password: "123456")
      # end
      @record.customer_id = customer.id if customer.present?
      @record.cashier_id = current_user.id
      @record.payment_method = params[:record][:payment_method]
      @record.customer_contact = params[:record][:customer_contact]
      @record.total_amount = total_amount

      if @record.save
        create_audit
        SendEmailNotificationJob.perform_later(@record)
        flash[:notice] = 'Record created successfully'
        redirect_to branch_record_path(@branch, @record)
      else
        flash[:alert] = 'Error While Creating Bill'
        redirect_to branch_records_path(@branch)
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
      redirect_to branch_records_path(@branch)
    else
      flash[:alert] = "Record could not be deleted."
      redirect_to branches_path
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
    params.require(:record).permit(:payment_method, :customer_contact)
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
        medicine_details: medicine_details
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
