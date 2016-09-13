class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :team_memberships
  has_many :people, through: :team_memberships
  has_many :invites

  mount_uploader :logo, ImageUploader

  def add_creator(person)
    self.people.push(person)
    self.save
  end

  def pending_invitations
    pending = []
    self.invites.each do |invite|
      unless self.people.include?(invite.recipient)
        pending.push(invite)
      end
    end
    return pending
  end
end
