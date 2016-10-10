class AddAddressToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :street_address, :string
    add_column :people, :locality, :string
    add_column :people, :region, :string
    add_column :people, :postal_code, :string
  end
end
