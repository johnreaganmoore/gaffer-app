class AddAssigneeToReminder < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :assignee_id, :integer
  end
end
