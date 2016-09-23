class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.belongs_to :season, foreign_key: true
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
