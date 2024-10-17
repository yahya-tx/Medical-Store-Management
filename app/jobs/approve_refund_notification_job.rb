class ApproveRefundNotificationJob < ApplicationJob
    queue_as :default
  
    def perform(user_id,order_id)
        message = "Your Request For Refund for Order #{order_id} is Approved By The Branch Admin"
        Notification.create(user_id: user_id, message: message, order_id: order_id,notification_type: "refund")
    end
end