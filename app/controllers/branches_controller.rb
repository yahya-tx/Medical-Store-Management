class BranchesController < ApplicationController
    before_action :set_branch, only: [:show, :update, :destroy, :edit]
  
    def index
      @branches = Branch.all
    end

    def new
      @branch = Branch.new
    end
  
    def show
    end
  
    def edit
    end
    def create
      @branch = Branch.create(branch_params)
      @branch.user_id = User.first.id
      if @branch.save
        redirect_to branch_path(@branch)
      else
        render :new
      end
    end
  
    def update
      if @branch.update(branch_params)
        redirect_to branch_path(@branch)
      else
        render :edit
      end
    end
  
    def destroy
      if @branch.destroy!
        flash[:notice] = "Branch deleted."
        redirect_to branches_path
      else
        flash[:alert] = "Branch could not be deleted."
        redirect_to branches_path
      end
    end
  
    private
  
    def set_branch
      @branch = Branch.find(params[:id])
    end
  
    def branch_params
      params.require(:branch).permit(:name, :location)
    end
end
  
