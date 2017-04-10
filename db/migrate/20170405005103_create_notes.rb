class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.references :contact
      t.text :body

      t.timestamps
    end
  end
end
