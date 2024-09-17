class NotificationsController < ApplicationController

    def index
        @unread_notifications = current_user.notifications.where(read: false)
        @read_notifications = current_user.notifications.where(read: true)
    end

    def show
        @notification = Notification.find_by(id: params[:id])
        @notification.update(read: true)
    end
end
