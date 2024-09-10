class StockTransfer < ApplicationRecord
  belongs_to :to_branch, class_name: 'Branch'
  belongs_to :requested_by, class_name: 'User'
  belongs_to :approved_by, class_name: 'User'
  belongs_to :branch

  enum :status, [:pending, :approved]
end
