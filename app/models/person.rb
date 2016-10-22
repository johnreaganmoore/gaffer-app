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

  def purchase(team_season, amount)
    SeasonParticipation.create(person_id: self.id, team_season_id: team_season.id, amount_paid: amount)
    self.teams.push(team_season.team)
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
    person = Person.create!(first_name: first_name, last_name: last_name, email: email, :password => temp_password, :password_confirmation => temp_password)
    PersonMailer.temp_password(person, temp_password).deliver
    return person
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
