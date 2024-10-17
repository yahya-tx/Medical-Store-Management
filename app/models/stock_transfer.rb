class StockTransfer < ApplicationRecord
  mount_uploader :pdf, PdfUploader

  belongs_to :to_branch, class_name: 'Branch'
  belongs_to :requested_by, class_name: 'User'
  belongs_to :approved_by, class_name: 'User'
  belongs_to :branch
  validates :quantity ,presence: true
  enum :status, [:pending, :approved]
end
