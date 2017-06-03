class AddOrgIdToInvite < ActiveRecord::Migration[5.0]
  def change
    add_reference :invites, :org, foreign_key: true
  end
end
