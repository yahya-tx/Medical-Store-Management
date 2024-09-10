class UserMailer < ApplicationMailer
    default from: 'no-reply@pharmacy.com'

    def purchase_notification(customer, record)
      @customer = customer
      @record = record
      mail(to: @customer.email, subject: 'Your Purchase Details')
    end
end
