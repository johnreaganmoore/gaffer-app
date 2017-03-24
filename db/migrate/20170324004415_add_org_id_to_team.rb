class AddOrgIdToTeam < ActiveRecord::Migration[5.0]
  def change
    add_reference :teams, :org, foreign_key: true
  end
end
