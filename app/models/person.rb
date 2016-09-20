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


  # This method overides default behavior to allow sign in for a confirmed person.
  # http://stackoverflow.com/questions/32191011/devise-devise-invitable-how-to-skip-the-pending-invitations-control
  # def block_from_invitation?
  #   #If the user has not been confirmed yet, we let the usual controls work
  #   if confirmed_at.blank?
  #     return invited_to_sign_up?
  #   else #if the user was confirmed, we let them in (will decide to accept or decline invitation from the dashboard)
  #     return false
  #   end
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

  protected

  def confirmation_required?
    false
  end

end
