class DenyRefundNotificationJob < ApplicationJob
    queue_as :default
  
    def perform(user_id,order_id)
        message = "Your Request For Refund Order #{order_id} is Denied By the Relative Branch Admin"
        Notification.create(user_id: user_id, message: message, order_id: order_id,notification_type: "refund_order")
    end
end