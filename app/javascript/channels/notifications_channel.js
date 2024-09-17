import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  received(data) {
    const notificationCountElement = document.getElementById("notification-count");
    if (notificationCountElement) {
      notificationCountElement.innerHTML = data.unread_count;
    }
  }
});
