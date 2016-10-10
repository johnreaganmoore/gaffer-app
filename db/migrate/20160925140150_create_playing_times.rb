class CreatePlayingTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :playing_times do |t|
      t.belongs_to :timeframe, foreign_key: true
      t.belongs_to :season, foreign_key: true

      t.timestamps
    end
  end
end
