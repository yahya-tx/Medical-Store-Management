class Notification < ApplicationRecord
  belongs_to :user
  enum :notification_type, [ :refund_order, :sale]
end
