class AddCreatorToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :creator_id, :integer
  end
end
