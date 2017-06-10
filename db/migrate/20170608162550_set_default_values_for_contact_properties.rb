class SetDefaultValuesForContactProperties < ActiveRecord::Migration[5.0]
  def change
    change_column_default :people, :show_contact_tags_in_table, true
    change_column_default :people, :show_contact_phone_in_table, false
    change_column_default :people, :show_contact_email_in_table, false
    change_column_default :people, :show_contact_next_task_in_table, true
    change_column_default :people, :show_contact_last_activity_in_table, true
  end
end
