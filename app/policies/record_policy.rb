class RecordPolicy < ApplicationPolicy
  def new?
    user.cashier?
  end
end
