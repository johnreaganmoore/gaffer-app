class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :team_id
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token

      t.timestamps
    end
  end
end
