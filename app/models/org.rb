class Org < ApplicationRecord
  # Set a slug to be used in the url based on the org name
  extend FriendlyId
  friendly_id :name, use: :slugged

  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']
  require "mailgun"

  # Enable setting rolify roles
  resourcify

  # Set Relationships
  has_many :invites
  has_many :leagues
  has_many :sub_lists
  has_many :teams
  has_many :contacts
  has_many :contact_properties
  has_many :email_templates
  acts_as_tagger

  after_create :populate_first_contact

  def populate_first_contact
    @contact = Contact.create(
      first_name: "John Reagan",
      last_name: "Moore",
      phone: "978-998-2205",
      email: "johnreagan@playonside.com",
      org_id: self.id
    )
    @contact.tag_list.add("Software Partner")
    @contact.save
    Reminder.create(
      label: "Email John Reagan with any questions or feedback about the software",
      next_date: DateTime.now.beginning_of_day + 8.hours + 7.days,
      interval: "one-time",
      contact_id: @contact.id,
      status: "incomplete"
    )
    Note.create(
      body: "<h3>Welcome!</h3><p><br></p><p>This is a simple way to take notes related to people. You can simply edit the formatting of the text or add links by <b>highlighting</b> it. You can also add images if you want by dragging them into this text area.<br><br>You can just edit or delete this note and be on your way. If you need any help please always feel free to contact us directly in the chat bubble at the bottom right of the screen.<br><br>Thanks,<br><br>John Reagan</p>",
      contact_id: @contact.id
    )

  end

  def admins
    Person.with_role(:admin, self)
  end

  def primary_admin
    Person.with_role(:admin, self).first
  end

  def send_reminder_email

    mg_client = Mailgun::Client.new 'key-30c362ad4107dd2bc3f9fffc67bd23b6'

    email_main = ""

    tasks = []

    self.contacts.each do |contact|
      tasks += contact.reminders.where("status = ? AND next_date <= ?", "incomplete", Date.today)
    end

    task_strings = []
    tasks.each do |task|
      task_strings.push("\n - #{task.contact.first_name} #{task.contact.last_name}: #{task.label}")
    end

    puts task_strings.inspect

    if tasks.length == 1
      email_main =
      "\nHere is your task for the day: #{task_strings[0]}"
    else
      email_main =
      "\nHere are your tasks for the day: #{task_strings.join('')}"
    end

    # puts task_strings[0]
    # puts self.primary_admin.inspect
    # puts self.admins.inspect

      # Define your message parameters
    message_params =  { from: 'reminders@playonside.com',
                        to:   self.primary_admin.email,
                        subject: "your tasks for the day",
                        text: "Hey #{self.primary_admin.first_name},
                        #{email_main}
                        \nYou got this!
                        "
                      }

    # Send your message through the client
    mg_client.send_message 'playonside.com', message_params

  end

  def create_managed_account(admin)
    account_props = {
      managed: true,
      transfer_schedule: {
        interval: "daily"
      },
      country: 'US',
      email: admin.email,
      legal_entity: {
        type: "company",
        dob: {
          day: admin.date_of_birth.strftime("%d").to_i,
          month: admin.date_of_birth.strftime("%m").to_i,
          year: admin.date_of_birth.strftime("%Y").to_i
        },
        first_name: admin.first_name,
        last_name: admin.last_name,
      }

    }
    result = Stripe::Account.create(account_props)
    self.merchant_account_id = result.id
    self.save
  end

  def record_accept_terms(ip)
    account = Stripe::Account.retrieve(self.merchant_account_id)
    account.tos_acceptance.date = Time.now.to_i
    account.tos_acceptance.ip = ip # Assumes you're not using a proxy
    account.save
  end


end
