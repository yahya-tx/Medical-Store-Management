class UpdateNotificationsCustomerToUserId < ActiveRecord::Migration[7.1]
  def change
    rename_column :notifications, :customer_id, :user_id
    remove_column :notifications, :sent_at

    add_foreign_key :notifications, :users, column: :user_id
  end
end
