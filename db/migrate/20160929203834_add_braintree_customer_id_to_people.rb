class AddBraintreeCustomerIdToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :braintree_customer_id, :string
  end
end
