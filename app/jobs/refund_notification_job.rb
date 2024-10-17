class RefundNotificationJob < ApplicationJob
    queue_as :default
  
    def perform(user_id,message,order_id)
       Notification.create(user_id: user_id, message: message, order_id: order_id,notification_type: "refund_order")
    end
end
