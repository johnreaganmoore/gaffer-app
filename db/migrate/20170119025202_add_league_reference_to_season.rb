class AddLeagueReferenceToSeason < ActiveRecord::Migration[5.0]
  def change
    add_reference :seasons, :league, foreign_key: true
  end
end
