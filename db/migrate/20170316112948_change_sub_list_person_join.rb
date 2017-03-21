class ChangeSubListPersonJoin < ActiveRecord::Migration[5.0]
  def change

    remove_column :people, :sub_list_id

    create_table :sub_list_membership do |t|
      t.references :person, foreign_key: true
      t.references :sub_list, foreign_key: true

      t.timestamps
    end

  end
end
