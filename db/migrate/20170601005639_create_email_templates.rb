class CreateEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :email_templates do |t|
      t.text :body
      t.string :name
      t.references :org, foreign_key: true

      t.timestamps
    end
  end
end
