class AddSubscriptionsToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :subscriptions, :string, array: true, default: []
  end
end
