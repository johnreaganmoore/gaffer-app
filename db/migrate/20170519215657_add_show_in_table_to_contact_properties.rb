class AddShowInTableToContactProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :contact_properties, :show_in_table, :boolean
  end
end
