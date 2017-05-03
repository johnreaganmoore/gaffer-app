class CreateContactProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_properties do |t|
      t.string :property
      t.references :org, foreign_key: true

      t.timestamps
    end
  end
end
