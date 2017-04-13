class AddStatusToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :status, :string
  end
end
