class DispatchOrderNotificationJob < ApplicationJob
  queue_as :default
  
  def perform(user_id, message)
    Notification.create(user_id: user_id, message: message)
  end
end