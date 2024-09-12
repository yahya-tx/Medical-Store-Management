class NotificationJob < ApplicationJob
  queue_as :default

  def perform(user, message)
    Notification.create(user_id: user.id, message: message)
  end
end
