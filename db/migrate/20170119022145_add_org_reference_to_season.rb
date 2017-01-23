class AddOrgReferenceToSeason < ActiveRecord::Migration[5.0]
  def change
    add_reference :seasons, :org, foreign_key: true
  end
end
