class Contact < ApplicationRecord
  belongs_to :org
  acts_as_taggable

  has_many :notes
  has_many :reminders



  before_save :set_tag_owner
  def set_tag_owner
    # Set the owner of some tags based on the current tag_list
    set_owner_tag_list_on(self.org, :tags, self.tag_list)
    # Clear the list so we don't get duplicate taggings
    self.tag_list = nil
  end

  def next_reminder
    next_overall_date = nil
    self.reminders.each do |reminder|
      if next_overall_date == nil || reminder.next_date > next_overall_date
        next_overall_date = reminder.next_date
      end
    end
    return next_overall_date
  end

  def latest_activity
    latest_date = self.updated_at

    reminder_date = latest_date
    if self.reminders.length > 0
      reminder_date = self.reminders.sort_by(&:updated_at).first.updated_at
    end

    note_date = latest_date
    if self.notes.length > 0
      note_date = self.notes.sort_by(&:updated_at).first.updated_at
    end

    # reminder_date = self.reminders.first(:order => "updated_at DESC")
    # note_date = self.notes.first(:order => "updated_at DESC")

    if reminder_date > latest_date
      latest_date = reminder_date
    end

    if note_date > latest_date
      latest_date = note_date
    end

    return latest_date

  end

end
