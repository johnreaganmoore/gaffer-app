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
