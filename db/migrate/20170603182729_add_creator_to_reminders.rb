class AddCreatorToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :creator_id, :integer
  end
end
