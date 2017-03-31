class RenamePersonFeesToPlayerFees < ActiveRecord::Migration[5.0]
  def change
    rename_table :person_fees, :player_fees
  end
end
