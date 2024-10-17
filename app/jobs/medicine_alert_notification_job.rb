class MedicineAlertNotificationJob < ApplicationJob
    queue_as :default
  
    def perform
        medicines = Medicine.where("quantity < ?", 5) 
        
        medicines.each do |medicine|
            branch_admins = User.branch_admin.where(branch_id: medicine.branch_id)
            
            branch_admins.each do |admin|
                Notification.create(user_id: admin.id, message: "Low stock alert: Medicine '#{medicine.name}' has less than 5 units left.")
            end
        end
    end
end
