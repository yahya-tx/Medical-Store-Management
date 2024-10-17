class Refund < ApplicationRecord
    belongs_to :customer, class_name: 'User'
    belongs_to :branch
    belongs_to :branch_admin, class_name: 'User'
    belongs_to :record 

    enum :status, [ :pending, :approved, :denied]
end
  