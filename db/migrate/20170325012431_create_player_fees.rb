class CreatePlayerFees < ActiveRecord::Migration[5.0]
  def change
    create_table :person_fees do |t|
      t.references :person, foreign_key: true
      t.references :fee, foreign_key: true
      t.boolean :paid
      t.integer :amount
      t.string :charge

      t.timestamps
    end
  end
end
