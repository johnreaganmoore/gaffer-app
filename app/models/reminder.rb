class Reminder < ApplicationRecord
  belongs_to :contact, touch: true

  require "mailgun"

  after_save :notify

  def notify

    recipient_email = self.contact.org.primary_admin.email
    recipient = self.contact.org.primary_admin

    mg_client = Mailgun::Client.new 'key-30c362ad4107dd2bc3f9fffc67bd23b6'

      # Define your message parameters
    message_params =  { from: 'reminders@playonside.com',
                        to:   recipient_email,
                        subject: "Reminder for #{self.contact.first_name} #{self.contact.last_name}",
                        text: "Hey #{recipient.first_name},
                        \nThis is a reminder you set for #{self.contact.first_name} #{self.contact.last_name}(#{self.contact.email}): #{self.label}
                        \nYou got this!
                        "
                      }

    # Send your message through the client
    mg_client.send_message 'playonside.com', message_params
    self.clean_reminder
  end

  def clean_reminder
    case self.interval
    when "daily"
      self.next_date = self.next_date + 1.day
      self.save
    when "weekly"
      self.next_date = self.next_date + 1.week
      self.save
    when "monthly"
      self.next_date = self.next_date + 1.month
      self.save
    when "annually"
      self.next_date = self.next_date + 1.year
      self.save
    else
      # self.delete
    end
  end

  def when_to_run
    self.next_date.beginning_of_day + 8.hours
  end

  handle_asynchronously :notify, :run_at => Proc.new { |i| i.when_to_run }
end
