class CreateArchives < ActiveRecord::Migration[7.1]
  def change
    create_table :archives do |t|
      t.jsonb :archive_data
      t.datetime :archived_at

      t.timestamps
    end
  end
end
