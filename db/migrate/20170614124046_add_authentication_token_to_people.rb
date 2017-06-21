class AddAuthenticationTokenToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :authentication_token, :string, limit: 30
    add_index :people, :authentication_token, unique: true
  end
end
