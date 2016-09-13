class Invite < ApplicationRecord
  belongs_to :team
  belongs_to :sender, :class_name => 'Person'
  belongs_to :recipient, :class_name => 'Person'

  before_create :generate_token
  before_save :check_user_existence


  def generate_token
    self.token = Digest::SHA1.hexdigest([self.team_id, Time.now, rand].join)
  end

  def check_user_existence
    recipient = Person.find_by_email(email)
    if recipient
      self.recipient_id = recipient.id
    end
  end

end
