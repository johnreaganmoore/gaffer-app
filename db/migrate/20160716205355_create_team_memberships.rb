class CreateTeamMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_memberships do |t|
      t.string :position
      t.references :team, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
