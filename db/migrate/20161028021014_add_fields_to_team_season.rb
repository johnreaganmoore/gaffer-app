class AddFieldsToTeamSeason < ActiveRecord::Migration[5.0]
  def change
    add_column :team_seasons, :status, :string #open, closed, archived
    add_column :team_seasons, :max_players, :integer
  end
end
