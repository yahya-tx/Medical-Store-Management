class MedicinesController < ApplicationController
  before_action :set_medicine, only: [:show, :update, :destroy, :edit]
  before_action :set_branch, only: [:new, :create, :edit, :update, :index,:show, :destroy]

  def index
    @medicines = @branch.medicines
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
      redirect_to branch_medicine_path(@branch, @medicine)
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
      redirect_to branch_medicine_path(@branch, @medicine)
    else
      flash.now[:alert] = "Error updating medicine."
      render :edit
    end
  end

  def destroy
    if @medicine.destroy
      flash[:notice] = "#{@medicine.name} has been successfully deleted."
      redirect_to branch_medicines_path(@branch)
    else
      flash[:alert] = "Medicine could not be deleted."
      redirect_to branch_medicines_path(@branch)
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
    params.require(:medicine).permit(:name, :description, :price, :quantity, :product_code, :branch_id)
  end
end
