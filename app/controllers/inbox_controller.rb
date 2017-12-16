class InboxController < ApplicationController
  layout "relate"

  before_action :authenticate_person!
  before_action :active_org, :set_current_person_tasks, :set_unassigned_tasks, :set_new_submissions, :get_due_tasks

  def all
    # @new_submissions = @active_org.submissions.where(status: "new").order('updated_at DESC')
    @approved_submissions = @active_org.submissions.where(status: "approved").order('updated_at DESC')
    @rejected_submissions = @active_org.submissions.where(status: "rejected").order('updated_at DESC')
    @maybe_submissions = @active_org.submissions.where(status: "maybe").order('updated_at DESC')

    @contacts = @active_org.contacts

    items = @current_person_tasks + @unassigned_tasks + @new_submissions + @approved_submissions + @rejected_submissions + @maybe_submissions

    @inbox_items = items.sort!{|b,a| a.created_at <=> b.created_at}

    @reminders = Reminder.all

  end

end
