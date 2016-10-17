class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.string :website
      t.string :location
      t.date :start_date
      t.date :end_date
      t.integer :cost
      t.integer :total_games
      t.string :format

      t.timestamps
    end
  end
end
