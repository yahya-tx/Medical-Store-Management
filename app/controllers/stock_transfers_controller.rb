class StockTransfersController < ApplicationController
  before_action :set_branch, only: [:create, :new, :index, :show, :update, :destroy, :edit,:upload_pdf]
  before_action :set_stock_transfer, only: [:show, :update, :destroy, :edit,:upload_pdf]

  def new
    @stock_transfer = @branch.stock_transfers.new
  end

  def index
    if current_user.super_admin?
      @stock_transfers = @branch.stock_transfers.where.not(pdf: nil).where(approved_by_id: current_user.id)
    else
      @stock_transfers = @branch.stock_transfers
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StockTransferPdfGenerator.new(@stock_transfer).generate
        send_data pdf.render, filename: "stock_transfer_#{@stock_transfer.id}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def upload_pdf
    if @stock_transfer.update(stock_transfer_params)
      @stock_transfer.update(requested_by_id: current_user.id)
      flash[:notice] = 'PDF uploaded successfully'
      redirect_to branch_stock_transfer_path(@branch, @stock_transfer)
    else
      flash[:alert] = 'Failed to upload PDF'
      render :show
    end
  end

  def create
    @stock_transfer = @branch.stock_transfers.new(stock_transfer_params)

    if handle_medicines(params[:stock_transfer][:medicine_name], params[:stock_transfer][:quantity])
      if @stock_transfer.save
        flash[:notice] = 'Stock Transfer created successfully'
        redirect_to branch_stock_transfer_path(@branch, @stock_transfer)
      else
        flash[:alert] = "Invalid Quantity or Medicine not available for Stock Transfer"
        redirect_to  branch_stock_transfers_path(@branch)
      end
    else
      flash[:alert] = "Invalid Quantity or Medicine not available for Stock Transfer"
      redirect_to  branch_stock_transfers_path(@branch)
    end
  end

  def edit
  end

  def update
    if handle_medicines(params[:stock_transfer][:medicine_name], params[:stock_transfer][:quantity])
      if @stock_transfer.update(stock_transfer_params)
        flash[:notice] = 'Stock Transfer updated successfully'
        redirect_to branch_stock_transfer_path(@branch, @stock_transfer)
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def approve
    stock_transfer = StockTransfer.find_by(id: params[:id])
    stock_transfer.medicine_ids.each do |med|
      medicine = Medicine.find_by('lower(name) = ?', med['name'].downcase)
      old_quantity = medicine.quantity
      stock_quantity = med['quantity']
      if medicine.present? 
        if old_quantity > stock_quantity && medicine.branch_id == stock_transfer.to_branch_id
          medicine.update(quantity: (old_quantity - stock_quantity))
        end
      else
        flash[:alert] = "Cant Transfer Stock Due to invalid Credentials"
        redirect_to branch_stock_transfer_path(@branch, @stock_transfer)
      end
      requested_branch_medicine =  Medicine.find_by('lower(name) = ? AND branch_id = ?', med['name'].downcase, stock_transfer.branch_id)
      if requested_branch_medicine.present?
        new_quantity = requested_branch_medicine.quantity + stock_quantity
        requested_branch_medicine.update(quantity: new_quantity)
      else
        Medicine.create(
          name: medicine.name,
          quantity: med["qunatity"],
          product_code: medicine.product_code,
          price: medicine.price,
          branch_id: stock_transfer.branch_id

        )
      end
    end
    if stock_transfer.update(status: 'approved', approved_by_id: current_user.id)
      user = User.find_by(id: stock_transfer.requested_by_id)
      message = "Your Stock transfer request is approved by #{current_user.name}"
      NotificationJob.perform_later(user,message)
      flash[:notice] = 'Stock transfer approved successfully.'
    else
      flash[:alert] = 'Failed to update stock transfer status.'
    end
    redirect_to branch_stock_transfer_path(stock_transfer.branch_id, stock_transfer)
  end

  def destroy
    if @stock_transfer.destroy
      flash[:alert] = 'Stock Transfer deleted successfully'
      redirect_to branch_stock_transfers_path(@branch)
    else
      flash[:alert] = 'Error While Deleting Stock Transfer'
      redirect_to branch_stock_transfers_path(@branch)
    end
  end

  private



  def set_branch
    @branch = Branch.find(params[:branch_id])
  end

  def set_stock_transfer
    @stock_transfer = @branch.stock_transfers.find(params[:id])
  end

  def stock_transfer_params
    params.require(:stock_transfer).permit(:quantity, :to_branch_id, :approved_by_id, :pdf)
  end

  def handle_medicines(medicine_names, quantities)
    if medicine_names.size == quantities.size
      @stock_transfer.medicine_ids.clear
      total_quantity = 0

      medicine_names.each_with_index do |name, index|
        medicine = Medicine.find_by('lower(name) = ? AND branch_id = ?', name.downcase, params[:stock_transfer][:to_branch_id].to_i)
        quantity = quantities[index].to_i
        if medicine.present?
          if medicine.quantity >= quantity
            @stock_transfer.medicine_ids << { medicine_id: medicine.id, name: medicine.name, code: medicine.product_code, quantity: quantity }
            total_quantity += quantity
          else
            flash[:alert] = "Insufficient stock for #{medicine.name}"
            return
          end
        else
          flash[:alert] = "Medicine '#{name}' not found"
          return
        end
      end

      @stock_transfer.quantity = total_quantity
      @stock_transfer.branch_id = @branch.id
      @stock_transfer.to_branch_id = params[:stock_transfer][:to_branch_id]
      @stock_transfer.status = "pending"
      @stock_transfer.requested_by_id = current_user.id
      @stock_transfer.approved_by_id = params[:stock_transfer][:approved_by_id]

    else
      flash[:alert] = "Medicine names and quantities mismatch"
      return
    end
  end
end
