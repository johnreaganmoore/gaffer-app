class Person < ApplicationRecord
  rolify
  include ActionView::Helpers::NumberHelper

  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']


  # Include default devise modules. Others available are:
  # :lockable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_many :team_memberships
  has_many :teams, through: :team_memberships

  has_many :season_participations
  has_many :seasons, through: :season_participations

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  mount_uploader :avatar, ImageUploader

  # after_initialize :ensure_avatar
  after_update :ensure_avatar
  after_update :new_managed_account?

  # after_create :assign_default_role
  #
  # def assign_default_role
  #   self.add_role(:new_person) if self.roles.blank?
  # end

  def self.from_omniauth(auth)

    where(provider: auth.provider, uid: auth.uid).first_or_create do |person|

      person.email = auth.info.email
      person.password = Devise.friendly_token[0,20]
      person.skip_confirmation!
      # person.name = auth.info.name   # assuming the person model has a name
      # person.image = auth.info.image # assuming the person model has an image
    end
  end

  def leave_team(team)
    self.teams.destroy(team)
  end

  def has_payment_info?
    customer_id
  end

  # Cost is cost in cents integer
  # service_fee_rate is the percentage we are charging as the onside fee as a decimal
  # discount_rate is the percentage of the fee we are taking off as a decimal(eg 100% discount = 1.0, 50% off = 0.5)
  def payment_composition(cost, service_fee_rate, discount_rate)

    adjusted_fee_rate = service_fee_rate * (1 - discount_rate)
    # fee_multiplier = 1 + adjusted_fee_rate
    service_fee = (cost * adjusted_fee_rate).round(-2).to_i

    charge_amount = cost + service_fee
    stripe_fee = (charge_amount * ENV['stripe_percentage'].to_f).ceil + ENV['stripe_flat'].to_i
    onside_net = service_fee - stripe_fee

    composition = {
      charge_amount: charge_amount.to_i,
      season_fee: cost,
      service_fee: service_fee,
      stripe_fee: stripe_fee,
      onside_net: onside_net
    }

    # puts composition.inspect

  end

  def purchase_season(team_season, recipient_id, expected_cost)

    season_participation = self.season_participations.where(team_season_id: team_season.id).first
    if season_participation != nil
      if season_participation.amount_paid != nil
        amount_paid = season_participation.amount_paid
      else
        amount_paid = 0
      end
    else
      amount_paid = 0
    end

    # check to see if person owes money for team_season
    if amount_paid >= expected_cost
      # Display error saying they have already signed up and paid
      return {success: true, already_paid: true}
    else
      # Pay balance
      # Process a transaction for the balance of the amount for the season and update the SeasonParticipation accordingly
      amount_owed = expected_cost - amount_paid
      comp = self.payment_composition(amount_owed, 0.05, 0)

      customer = Stripe::Customer.retrieve(self.customer_id)

      result = Stripe::Charge.create({
        amount: comp[:charge_amount],
        currency: "usd",
        # source: token.id,
        customer: customer.id,
        description: "Season Fee",
        application_fee: comp[:service_fee], # amount in cents
        destination: recipient_id
        }
      )

      # if payment goes through increment their paid amount.
      if result.status == "succeeded"

        #Increment existing season
        if season_participation != nil
          season_participation.amount_paid = amount_paid + amount_owed
          season_participation.transactions.push(result.id)
          season_participation.save
        else
        # Create season participation
          season_participation = SeasonParticipation.create(person_id: self.id, team_season_id: team_season.id, amount_paid: amount_owed, transactions: [result.id])

          if team_season.season_participations.length == 1
            puts "should set treasurer"

            season_participation.is_treasurer = true
            season_participation.save
          end

          self.teams.push(team_season.team)
          # PersonMailer.new_team_member(self, team_season).deliver
        end
      end
      return result

    end
  end

  def new_managed_account?

    if self.date_of_birth_changed?(from: nil) && self.merchant_account_id == nil
      puts "Trying to create sub merchant"
      # create_sub_merchant
      result = create_managed_account
      self.merchant_account_id = result.id
      self.save
    end

  end

  def self.create_with_temp_pass(first_name, last_name, email)
    temp_password = Devise.friendly_token.first(8)

    person = Person.find_by_email(email)

    if person == nil
      person = Person.create!(first_name: first_name, last_name: last_name, email: email, :password => temp_password, :password_confirmation => temp_password)
      # PersonMailer.temp_password(person, temp_password).deliver
    end

    return person
  end

  def create_customer(token)
    result = Stripe::Customer.create(
      email: self.email,
      description: "Customer for #{self.email}",
      source: token # obtained with Stripe.js
    )

    self.customer_id = result.id
    self.save
    return self
  end

  def create_managed_account
    account_props = {
      managed: true,
      transfer_schedule: {
        interval: "manual"
      },
      country: 'US',
      email: self.email,
      legal_entity: {
        type: "individual",
        address: {
          city: self.locality,
          country: 'US',
          line1: self.street_address,
          line2: "",
          postal_code: self.postal_code,
          state: self.region
        },
        dob: {
          day: self.date_of_birth.strftime("%d").to_i,
          month: self.date_of_birth.strftime("%m").to_i,
          year: self.date_of_birth.strftime("%Y").to_i
        },
        first_name: self.first_name,
        last_name: self.last_name,
      }

    }
    result = Stripe::Account.create(account_props)
  end

  def add_external_account

    customer = Stripe::Customer.retrieve(self.customer_id)

    token = Stripe::Token.create(
      {:customer => customer.id, :card => customer.default_source},
      {:stripe_account => self.merchant_account_id} # id of the connected account
    )

    account = Stripe::Account.retrieve(self.merchant_account_id)
    account.external_accounts.create(
      external_account: token.id,
      default_for_currency: true
    )

  end

  def record_accept_terms(ip)
    account = Stripe::Account.retrieve(self.merchant_account_id)
    account.tos_acceptance.date = Time.now.to_i
    account.tos_acceptance.ip = ip # Assumes you're not using a proxy
    account.save
  end

  def last_four
    account = Stripe::Account.retrieve(self.merchant_account_id)

    account.external_accounts.data.each do |account|
      if account.default_for_currency == true
        return account.last4
      end
    end

  end

  def refund(charge, amount)
    refund = Stripe::Refund.create(
      charge: charge,
      amount: amount
    )
  end

  def administered_orgs
    orgs = []

    self.roles.where(:resource_type == "Org").each do |role|
      orgs.push(Org.find(role.resource_id))
    end

    return orgs
  end

  def take_admin_org
    role = self.roles.where(:resource_type == "Org").take
    if role != nil
      org = Org.find(role.resource_id)
      return org
    else
      return false
    end
  end

  protected

  def confirmation_required?
    false
  end

  def ensure_avatar
    image_file = File.open("app/assets/images/anonymous_material.png", "rb")

    if self.avatar.file.nil?
      self.avatar = image_file
      self.save
    end
  end

end
