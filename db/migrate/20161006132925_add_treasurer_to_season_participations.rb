class AddTreasurerToSeasonParticipations < ActiveRecord::Migration[5.0]
  def change
    add_column :season_participations, :is_treasurer, :boolean
  end
end
