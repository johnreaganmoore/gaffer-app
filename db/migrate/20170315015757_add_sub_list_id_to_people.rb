class AddSubListIdToPeople < ActiveRecord::Migration[5.0]
  def change
    add_reference :people, :sub_list, foreign_key: true
  end
end
