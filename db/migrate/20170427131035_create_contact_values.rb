class CreateContactValues < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_values do |t|
      t.references :contact, foreign_key: true
      t.references :contact_property, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
