class Season < ApplicationRecord
  belongs_to :league

  has_many :playing_times
  has_many :timeframes, through: :playing_times

  has_many :team_seasons, inverse_of: :season
  accepts_nested_attributes_for :team_seasons

  has_one :default_location, :class_name => "Location"

  after_create :ensure_cost
  # after_update :update_default_location
  before_save :update_default_location, if: :location_changed?

  def cost_per_player_estimate
    (self.cost/self.team_size_estimate).round
  end

  def team_size_estimate
    (self.league.players_per_team * 1.6).round
  end

  private

  def ensure_cost
    self.cost ||= 0
    self.save
  end

  # def add_default_location
  #   address = self.location
  #   self.default_location = Location.create({address: address} )
  #   self.save
  # end

  def update_default_location
    address = self.location
    self.default_location = Location.create({ address: address, latitude: self.location_lat, longitude: self.location_long })
    # self.save
  end

end
