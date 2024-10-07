class SendEmailNotificationJob < ApplicationJob
  queue_as :default

  def perform(record, user)
    if user.cashier?
      customer = User.find_by(phone_number: record.customer_contact, role: 'customer')
    else
      customer = user
    end
    if customer.present?
      UserMailer.purchase_notification(customer, record).deliver_later
    end
  end
end
