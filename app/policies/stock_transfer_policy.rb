class StockTransferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create
    user.super_admin? || user.branch_admin?
  end

  def update
    user.super_admin? || user.branch_admin?
  end

  def approve?
    user.super_admin?
  end
end
