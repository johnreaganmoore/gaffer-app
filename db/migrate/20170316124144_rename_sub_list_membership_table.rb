class RenameSubListMembershipTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :sub_list_membership, :sub_list_memberships
  end
end
