class Season < ApplicationRecord
  has_many :playing_times
  has_many :timeframes, through: :playing_times

  has_many :team_seasons, inverse_of: :season
  accepts_nested_attributes_for :team_seasons

  has_one :default_location, :class_name => "Location"

  after_create :add_default_location, :ensure_cost
  after_update :update_default_location

  private

  def ensure_cost
    self.cost ||= 0
    self.save
  end

  def add_default_location
    address = self.location
    self.default_location = Location.create({address: address} )
  end

  def update_default_location
    address = self.location
    self.default_location = Location.create({address: address} )
  end

end
