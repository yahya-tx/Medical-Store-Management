class OrderNotificationJob < ApplicationJob
    queue_as :default
  
    def perform(user_ids, message, order_id)
        user_ids.each do |user_id|
        Notification.create(user_id: user_id, message: message, order_id: order_id)
        end
    end
end
  