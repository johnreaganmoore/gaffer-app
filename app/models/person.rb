class Person < ApplicationRecord
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
  after_update :new_sub_merchant?

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
    braintree_customer_id
  end

  def purchase_season(team_season, nonce)

    base_cost = team_season.new_player_cost
    service_fee = team_season.new_player_cost * 0.10
    total_cost = base_cost + service_fee

    season_participation = self.season_participations.where(team_season_id: team_season.id).first
    if season_participation != nil
      amount_paid = season_participation.amount_paid
    else
      amount_paid = 0
    end

    # check to see if person owes money for team_season
    if amount_paid >= team_season.new_player_cost
      # Display error saying they have already signed up and paid
      puts "You are already signed up and paid up!"
      return {success: true, already_paid: true}
    else
      # Pay balance
      # Process a transaction for the balance of the amount for the season and update the SeasonParticipation accordingly
      amount_owed = team_season.new_player_cost - amount_paid
      service_fee = amount_owed * 0.10
      # Make payment
      payment_params = {
        amount: amount_owed + service_fee,
        fee_amount: service_fee,
        merchant_account_id: team_season.treasurer.id,
        payment_method_nonce: nonce
      }
      result = self.pay(payment_params)

      # if payment goes through increment their paid amount.
      if result.success?
        puts result.inspect
        #Increment existing season
        if season_participation != nil
          season_participation.amount = amount_paid + amount_owed
          season_participation.save
        else
        # Create season participation
          SeasonParticipation.create(person_id: self.id, team_season_id: team_season.id, amount_paid: amount_owed)
          self.teams.push(team_season.team)
        end
      end
      return result
    end

  end

  def new_sub_merchant?
    if self.date_of_birth_changed?(from: nil)
      puts "Trying to create sub merchant"
      create_sub_merchant
    end
  end

  def create_sub_merchant
    merchant_account_params = {
      :individual => {
        :first_name => self.first_name,
        :last_name => self.last_name,
        :email => self.email,
        :date_of_birth => self.date_of_birth,
        :address => {
          :street_address => self.street_address,
          :locality => self.locality,
          :region => self.region,
          :postal_code => self.postal_code
        }
      },
      :funding => {
        :descriptor => "Onside - Soccer Team Management App",
        :destination => Braintree::MerchantAccount::FundingDestination::Email,
        :email => self.email,
        # :mobile_phone => self.phone,
        # :account_number => "1123581321",
        # :routing_number => "071101307"
      },
      :tos_accepted => true,
      :master_merchant_account_id => "letsgoteam",
      :id => self.id
    }
    result = Braintree::MerchantAccount.create(merchant_account_params)

    puts "result"
    puts result.inspect
  end

  def update_sub_merchant
    result = Braintree::MerchantAccount.update(
      self.id,
      :individual => {
        :first_name => self.first_name,
        :last_name => self.last_name,
        :email => self.email,
        :date_of_birth => self.date_of_birth,
        :address => {
          :street_address => self.street_address,
          :locality => self.locality,
          :region => self.region,
          :postal_code => self.postal_code
        }
      },
      :funding => {
        :email => self.email,
      },
    )
    if result.success?
      p "Merchant account successfully updated"
    else
      p result.errors
    end
  end

  def self.create_with_temp_pass(first_name, last_name, email)
    temp_password = Devise.friendly_token.first(8)

    person = Person.find_by_email(email)

    if person == nil
      person = Person.create!(first_name: first_name, last_name: last_name, email: email, :password => temp_password, :password_confirmation => temp_password)
      PersonMailer.temp_password(person, temp_password).deliver
    end

    return person
  end



  def pay(p)
    unless self.has_payment_info?
      pay_and_create_customer(p[:amount], p[:fee_amount], p[:merchant_account_id], p[:payment_method_nonce])
    else
      pay_without_vaulting(p[:amount], p[:fee_amount], p[:merchant_account_id], p[:payment_method_nonce])
    end
  end

  def pay_and_create_customer(
    amount,
    fee_amount,
    merchant_account_id,
    payment_method_nonce
    )
    Braintree::Transaction.sale(
      merchant_account_id: merchant_account_id,
      amount: amount,
      service_fee_amount: fee_amount,
      payment_method_nonce: payment_method_nonce,
      customer: {
        first_name: self.first_name,
        last_name: self.last_name,
        email: self.email
      },
      options: {
        store_in_vault: true,
        submit_for_settlement: true,
        hold_in_escrow: true
      }
    )
  end

  def pay_without_vaulting(
    amount,
    fee_amount,
    merchant_account_id,
    payment_method_nonce
    )
    Braintree::Transaction.sale(
      merchant_account_id: merchant_account_id,
      amount: amount,
      service_fee_amount: fee_amount,
      payment_method_nonce: payment_method_nonce,
      options: {
        submit_for_settlement: true,
        hold_in_escrow: true
      }
    )
  end

  protected

  def confirmation_required?
    false
  end

  def ensure_avatar

    puts "Ensuring avatar"
    # puts self.inspect
    # puts "previous line is avatar"
    #
    # puts "File thingy will run"
    image_file = File.open("app/assets/images/anonymous_material.png", "rb")

    if self.avatar.file.nil?
      self.avatar = image_file
      self.save
    end



    puts self.inspect
  end

end
