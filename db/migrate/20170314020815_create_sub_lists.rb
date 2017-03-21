class CreateSubLists < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_lists do |t|
      t.string :name
      t.references :org, foreign_key: true

      t.timestamps
    end
  end
end
