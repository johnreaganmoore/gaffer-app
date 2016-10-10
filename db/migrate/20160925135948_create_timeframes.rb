class CreateTimeframes < ActiveRecord::Migration[5.0]
  def change
    create_table :timeframes do |t|
      t.string :day_of_week
      t.string :part_of_day

      t.timestamps
    end
  end
end
