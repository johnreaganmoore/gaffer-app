class Location < ApplicationRecord
  has_many :games
  has_many :seasons, through: :games

  belongs_to :season

  geocoded_by :address
  after_validation :geocode
  after_update :geocode

end
