class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.references :contact
      t.string :label
      t.date :next_date
      t.string :interval

      t.timestamps
    end
  end
end
