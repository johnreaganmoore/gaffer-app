class AddFieldsToLeague < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :players_per_team, :integer
    add_column :leagues, :minutes_per_game, :integer
    add_column :leagues, :facility_type, :string
  end
end
