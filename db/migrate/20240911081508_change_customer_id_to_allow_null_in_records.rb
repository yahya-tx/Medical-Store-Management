class ChangeCustomerIdToAllowNullInRecords < ActiveRecord::Migration[7.1]
  def change
    change_column_null :records, :customer_id, true
  end
end
