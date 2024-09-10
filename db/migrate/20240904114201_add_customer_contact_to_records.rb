class AddCustomerContactToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :customer_contact, :string
  end
end
