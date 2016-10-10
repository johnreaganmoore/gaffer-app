class AddFieldsToSeason < ActiveRecord::Migration[5.0]
  def change
    add_column :seasons, :sport, :string
  end
end
