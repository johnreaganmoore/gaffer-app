class AddLatAndLongToSeasons < ActiveRecord::Migration[5.0]
  def change
    add_column :seasons, :location_lat, :float
    add_column :seasons, :location_long, :float
  end
end
