class AddTransfersToTeamSeason < ActiveRecord::Migration[5.0]
  def change
    add_column :team_seasons, :transfers, :string, array: true, default: '{}'
  end
end
