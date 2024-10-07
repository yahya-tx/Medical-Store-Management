class V1::AuditLogsController < ApplicationController
  before_action :set_audit_log, only: [:show, :update, :destroy]
  before_action :set_branch, only: [:index, :new, :create, :show, :edit]

  def index
    @per_page = params[:per_page] || 2
    @audit_logs = @branch.audit_logs.page(params[:page]).per(@per_page)
  end
  

  def show
  end

  def new
    @audit_log = @branch.audit_logs.new
  end

  def create
  end

  def update
    if @audit_log.update(audit_log_params)
      flash[:notice] = "Audit Log updated successfully"
      redirect_to v1_branch_audit_logs_path(@audit_log.branch)
    else
      flash[:alert] = "Error while updating audit log information"
      render :edit
    end
  end

  def destroy
    if @audit_log.destroy
      flash[:notice] = "Audit Log deleted successfully"
      redirect_to v1_branch_audit_logs_path(@audit_log, @branch)
    else
      flash[:alert] = "Error while deleting audit log"
      redirect_to v1_branch_audit_logs_path(@audit_log.branch)
    end
  end

  private

  def set_audit_log
    @audit_log = AuditLog.find(params[:id])
  end

  def set_branch
    @branch = Branch.find(params[:branch_id])
  end

  def audit_log_params
    params.require(:audit_log).permit(:description)
  end
end
