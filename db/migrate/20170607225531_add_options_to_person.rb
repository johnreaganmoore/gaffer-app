class AddOptionsToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :show_contact_tags_in_table, :boolean
    add_column :people, :show_contact_phone_in_table, :boolean
    add_column :people, :show_contact_email_in_table, :boolean
    add_column :people, :show_contact_next_task_in_table, :boolean
    add_column :people, :show_contact_last_activity_in_table, :boolean
  end
end
