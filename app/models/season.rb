class Season < ApplicationRecord
  belongs_to :team
  has_many :season_participations
  has_many :people, through: :season_participations

  has_many :games
  has_many :locations, through: :games

  has_one :default_location, :class_name => "Location"

  after_create :add_default_location
  after_update :update_default_location

  private

  def add_default_location
    address = self.location
    self.default_location = Location.create({address: address} )
  end

  def update_default_location
    address = self.location
    puts address
    puts self.default_location.inspect
    self.default_location.update_attribute(:address, address)
    puts self.default_location.inspect
  end

end
