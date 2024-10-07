class V1::UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :set_branch, only: [:index, :show,:create,:new]
    def index
      @users = @branch.users.all
    end
  
    def show
      success_response(200, "User Information", @user)
    end
    def new
      @user = @branch.users.new
    end
    
  
    def create
      @user = @branch.users.new(user_params)
      if @user.save
        redirect_to v1_branch_users_path(@branch), notice: 'User was successfully created.'
      else
        render :new
      end
    end
    
    def update
      if @user.update(user_params)
        success_response(200, "User updated successfully", @user)
      else
        error_response(401, "Error while updating user information")
      end
    end
  
    def destroy
        if @user.destroy
          success_response(200, "User deleted successfully", @user)
        else
          error_response(401, "User not found")
        end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end

    def set_branch
      @branch = Branch.find_by(id: params[:branch_id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, :role, :branch_id)
    end
  end
  
