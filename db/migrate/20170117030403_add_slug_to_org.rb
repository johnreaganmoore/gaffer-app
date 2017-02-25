class AddSlugToOrg < ActiveRecord::Migration[5.0]
  def change
    add_column :orgs, :slug, :string, unique: true
  end
end
