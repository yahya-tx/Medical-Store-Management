class AddNumberOfTabletsToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :number_of_tablets, :integer
    remove_column :records, :medicine_id, :integer
    remove_column :records, :status, :integer
  end
end
