class V1::MedicinesController < ApplicationController
  before_action :set_medicine, only: [:show, :update, :destroy, :edit]
  before_action :set_branch, only: [:new, :create, :edit, :update, :index,:show, :destroy,:expired_medicines]

  def index
    @per_page = params[:per_page]
  
    if params[:search].present?
      searched_medicines = Medicine.where('name ILIKE ?', "%#{params[:search]}%")
      @medicines = searched_medicines.where(branch_id: @branch.id)
      
      if @medicines.present?
        @medicines = @medicines.page(params[:page]).per(@per_page)  
      else
        @medicines = searched_medicines.page(params[:page]).per(@per_page) 
      end
    else
      @medicines = @branch.medicines.page(params[:page]).per(@per_page) 
    end
  end

  def show
  end

  def new
    @medicine = @branch.medicines.build
  end

  def create
    @medicine = @branch.medicines.build(medicine_params)
    if @medicine.save
      flash[:notice] = "Medicine created successfully."
      redirect_to v1_branch_medicine_path(@branch, @medicine)
    else
      flash.now[:alert] = "Error creating medicine."
      render :new
    end
  end

  def edit
  end

  def update
    if @medicine.update(medicine_params)
      flash[:notice] = "Medicine updated successfully."
      redirect_to v1_branch_medicine_path(@branch, @medicine)
    else
      flash.now[:alert] = "Error updating medicine."
      render :edit
    end
  end

  def expired_medicines
    @medicines = @branch.medicines.where(expired: true).page(params[:page]).per(params[:per_page])
  end

  def destroy
    if @medicine.destroy
      flash[:notice] = "#{@medicine.name} has been successfully deleted."
      redirect_to v1_branch_medicines_path(@branch)
    else
      flash[:alert] = "Medicine could not be deleted."
      redirect_to v1_branch_medicines_path(@branch)
    end
  end

  private

  def set_medicine
    @medicine = Medicine.find(params[:id])
  end

  def set_branch
    @branch = Branch.find(params[:branch_id])
  end

  def medicine_params
    params.require(:medicine).permit(:name, :description, :price, :quantity, :product_code, :branch_id, :expiry_date)
  end
end
