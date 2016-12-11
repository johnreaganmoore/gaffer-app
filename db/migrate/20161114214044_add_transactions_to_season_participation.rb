class AddTransactionsToSeasonParticipation < ActiveRecord::Migration[5.0]
  def change
    add_column :season_participations, :transactions, :string, array: true, default: '{}'
  end
end
