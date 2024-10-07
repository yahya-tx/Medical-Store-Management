class AddTrackingIdToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :tracking_id, :string
  end
end
