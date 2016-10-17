class CreateTeamSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :team_seasons do |t|
      t.belongs_to :team, foreign_key: true
      t.belongs_to :season, foreign_key: true
      t.integer :cost
      t.integer :min_players

      t.timestamps
    end
  end
end
