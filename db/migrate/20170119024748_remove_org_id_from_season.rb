class RemoveOrgIdFromSeason < ActiveRecord::Migration[5.0]
  def change
    remove_column :seasons, :org_id
  end
end
