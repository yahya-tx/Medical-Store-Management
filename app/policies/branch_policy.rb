class BranchPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # def update?
  #   user.branch_admin? || user.super_admin?
  # end

  # def create?
  #   user.super_admin?
  # end

  # def show?
  #   user.branch_admin?
  # end
end

