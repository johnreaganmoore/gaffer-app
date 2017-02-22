class AddMerchantAccountIdToOrg < ActiveRecord::Migration[5.0]
  def change
    add_column :orgs, :merchant_account_id, :string
  end
end
