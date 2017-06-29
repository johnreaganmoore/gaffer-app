class CreateSubmissionValues < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_values do |t|
      t.references :submission, foreign_key: true
      t.references :contact_property, foreign_key: true
      t.string :value
      t.float :number_value
      t.datetime :date_value

      t.timestamps
    end
  end
end
