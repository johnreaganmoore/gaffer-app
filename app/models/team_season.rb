class TeamSeason < ApplicationRecord
  # "team_id"
  # "season_id"
  # "cost"
  # "min_players"
  # "max_players"
  # "status"
  # "season_id"
  # "team_id"


  belongs_to :team
  belongs_to :season, inverse_of: :team_seasons

  has_many :season_participations
  has_many :people, through: :season_participations
  has_one :treasurer, class_name: "Person"

  has_many :games
  has_many :locations, through: :games

  has_many :playing_times
  has_many :timeframes, through: :playing_times

  # has_one :default_location, :class_name => "Location"

  accepts_nested_attributes_for :treasurer, :season

  after_create :ensure_team, :ensure_min_players, :open
  after_initialize :ensure_cost

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
    self.team.people.push(person)
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

  def paid_players
    self.season_participations.where(amount_paid >= self.new_player_cost)
  end

  def total_paid
    self.season_participations.sum(:amount_paid)
  end

  private

  def ensure_team
    if self.team != nil
      return self.team
    else
      self.team = Team.create_random
      self.save
    end
  end

  def ensure_min_players
    unless self.min_players != nil
      # self.min_players = self.season.format.first.to_i
      # self.save
      self.min_players = 5
    end
  end

  def ensure_cost
    self.cost ||= 0
    self.save
  end

  def open
    self.status = "open"
    self.save
  end

  def close
    self.status = "closed"
  end

  def archive
    self.status = "archived"
  end

end
