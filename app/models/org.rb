class Org < ApplicationRecord
  # Set a slug to be used in the url based on the org name
  extend FriendlyId
  friendly_id :name, use: :slugged

  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']

  # Enable setting rolify roles
  resourcify

  # Set Relationships
  has_many :leagues
  has_many :sub_lists
  has_many :teams
  has_many :contacts
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
      contact_id: @contact.id
    )
    Note.create(
      body: "<h3>Welcome!</h3><p><br></p><p>This is a simple way to take notes related to people. You can simply edit the formatting of the text or add links by <b>highlighting</b> it. You can also add images if you want by dragging them into this text area.<br><br>Check out <a href='http://playonside.com'><b>this video</b></a> to get a more in depth walk through of the product if you want, or you can just edit or delete this note and be on your way.<br><br>If you need any help please always feel free to contact us directly in the chat bubble at the bottom right of the screen.<br><br>Thanks,<br><br>John Reagan</p>",
      contact_id: @contact.id
    )

  end

  def admins
    Person.with_role(:admin, self)
  end

  def primary_admin
    Person.with_role(:admin, self).first
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
