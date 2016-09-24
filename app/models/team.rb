class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :team_memberships
  has_many :people, through: :team_memberships
  has_many :invites
  has_many :seasons
  accepts_nested_attributes_for :seasons

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

  def player_avatars
    avatars = []
    self.people.each do |person|
      if person.avatar.length > 2 then
        puts person.avatar
        avatars.push(person.avatar)
      end
    end
    puts avatars
    return avatars
  end

end
