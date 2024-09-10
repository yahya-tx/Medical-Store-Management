class SendEmailNotificationJob < ApplicationJob
  queue_as :default

  def perform(record)
    customer = User.find_by(phone_number: record.customer_contact, role: 'customer')
    if customer.present?
      UserMailer.purchase_notification(customer, record).deliver_later
    end
  end
end
