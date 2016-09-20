class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.belongs_to :team, foreign_key: true
      t.string :league_name
      t.string :website
      t.string :location
      t.date :start_date
      t.date :end_date
      t.integer :cost
      t.integer :total_games
      t.string :format
      t.integer :min_players

      t.timestamps
    end
  end
end
