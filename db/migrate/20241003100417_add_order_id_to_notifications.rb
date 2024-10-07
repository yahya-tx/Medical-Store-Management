class AddOrderIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :order_id, :integer
  end
end
