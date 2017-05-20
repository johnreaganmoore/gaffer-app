class ChangeTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :contact_properties, :type, :data_type
  end
end
