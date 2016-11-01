class SeasonParticipation < ApplicationRecord
  belongs_to :person
  belongs_to :season

  after_create :default_amount_paid

  private

  def default_amount_paid
    self.amount_paid ||= 0
    self.save
  end


end
