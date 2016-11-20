class AddMerchantAccountToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :merchant_account_id, :string
    rename_column :people, :braintree_customer_id, :customer_id
  end
end
