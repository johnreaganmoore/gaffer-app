class Fee < ApplicationRecord
  belongs_to :team
  has_many :player_fees

  def total_paid
    paid_amount = 0
    self.player_fees.each do |pfee|
      if pfee.paid
        paid_amount += pfee.amount
      end
    end
    return paid_amount      
  end
end
