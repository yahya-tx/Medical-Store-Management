class AddAddressDetailstoRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :address, :string
    add_column :records, :postal_code, :integer
  end
end
