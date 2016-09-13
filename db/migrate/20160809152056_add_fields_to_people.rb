class AddFieldsToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    add_column :people, :phone, :string
    add_column :people, :date_of_birth, :date
    add_column :people, :avatar, :string
  end
end
