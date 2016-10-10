class Season < ApplicationRecord
  belongs_to :team
  has_many :season_participations
  has_many :people, through: :season_participations
  has_one :treasurer, class_name: "Person"

  has_many :games
  has_many :locations, through: :games

  has_many :playing_times
  has_many :timeframes, through: :playing_times

  has_one :default_location, :class_name => "Location"

  accepts_nested_attributes_for :treasurer

  after_create :add_default_location, :ensure_team
  after_update :update_default_location

  def new_player_cost
    self.cost / self.cost_divisor
  end

  def cost_divisor
    if self.season_participations.length > self.min_players
      return self.season_participations.length
    else
      return self.min_players
    end
  end

  def add_creator(person)
    self.people.push(person)
  end

  def set_treasurer(person)
    sp = self.season_participations.where(person_id: person.id).first
    sp.is_treasurer = true
    sp.save
  end

  def treasurer
    self.season_participations.where(is_treasurer: true).first.person
  end

  def game_format
    self.format
  end

  private

  def add_default_location
    address = self.location
    self.default_location = Location.create({address: address} )
  end

  def update_default_location
    address = self.location
    self.default_location.update_attribute(:address, address)
  end

  def ensure_team
    if self.team != nil
      return self.team
    else
      self.team = Team.create_random
      self.save
    end
  end





end
