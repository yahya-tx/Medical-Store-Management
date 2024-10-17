class RemoveDuplicateForeignKeyFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :notifications, name: "fk_rails_b080fb4855"
  end
end
