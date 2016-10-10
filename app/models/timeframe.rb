class Timeframe < ApplicationRecord
  has_many :playing_times
  has_many :seasons, through: :playing_times

  def friendly_label
    "#{self.day_of_week} #{self.part_of_day}s"
  end

end
