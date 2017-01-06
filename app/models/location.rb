class Location < ApplicationRecord
  has_many :games
  has_many :seasons, through: :games

  belongs_to :season

  geocoded_by :address
  # after_validation :geocode
  after_create :geocode_by_address

  def geocode_by_address
    if self.latitude == nil
      puts "calling geocode_by_address in location model"
      self.geocode
    end
  end



end
