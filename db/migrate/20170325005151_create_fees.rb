class CreateFees < ActiveRecord::Migration[5.0]
  def change
    create_table :fees do |t|
      t.string :label
      t.integer :total_amount
      t.integer :player_amount
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
