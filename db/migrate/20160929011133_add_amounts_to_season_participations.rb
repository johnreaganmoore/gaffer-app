class AddAmountsToSeasonParticipations < ActiveRecord::Migration[5.0]
  def change
    add_column :season_participations, :amount_paid, :float
    add_column :season_participations, :amount_refunded, :float
  end
end
