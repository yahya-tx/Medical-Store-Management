class Record < ApplicationRecord
  mount_uploader :pdf, PdfUploader

  belongs_to :cashier, class_name: 'User'
  belongs_to :branch

  enum :payment_method, [ :cash, :online]

end
