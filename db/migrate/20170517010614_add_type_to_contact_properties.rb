class AddTypeToContactProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :contact_properties, :type, :string
  end
end
