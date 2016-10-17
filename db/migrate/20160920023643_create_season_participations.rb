class CreateSeasonParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :season_participations do |t|
      t.references :person, foreign_key: true
      t.references :team_season, foreign_key: true

      t.timestamps
    end
  end
end
