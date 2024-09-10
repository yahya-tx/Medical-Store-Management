class Record < ApplicationRecord
  belongs_to :customer, class_name: 'User'
  belongs_to :cashier, class_name: 'User'
  belongs_to :branch

  enum :payment_method, [ :cash, :online]

end
