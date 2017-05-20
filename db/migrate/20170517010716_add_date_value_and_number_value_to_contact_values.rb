class AddDateValueAndNumberValueToContactValues < ActiveRecord::Migration[5.0]
  def change
    add_column :contact_values, :date_value, :datetime
    add_column :contact_values, :number_value, :float
  end
end
