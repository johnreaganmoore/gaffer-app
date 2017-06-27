class CreateHooks < ActiveRecord::Migration[5.0]
  def change
    create_table :hooks do |t|
      t.references :person, foreign_key: true
      t.string :target_url
      t.string :event

      t.timestamps
    end
  end
end
