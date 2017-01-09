class TeamSeason < ApplicationRecord
  # "team_id"
  # "season_id"
  # "cost"
  # "min_players"
  # "max_players"
  # "status"
  # "season_id"
  # "team_id"


  require "stripe"
  Stripe.api_key = ENV['stripe_api_key']

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
    ((self.cost * 100)  / self.cost_divisor.to_f).ceil
  end

  def last_player_cost
    if self.season_participations.length >= self.min_players
      return ((self.cost * 100)  / (self.cost_divisor - 1.0)).ceil
    else
      return new_player_cost
    end
  end

  def lowest_possible_cost
    if self.max_players != nil
      base = ((self.cost * 100)  / self.max_players.to_f).ceil
      fee = (base * 0.05).ceil
      base + fee
    else
      nil
    end
  end

  def spots_remaining
    self.max_players - self.season_participations.length
  end

  def cost_divisor
    if self.season_participations.length >= self.min_players
      return self.season_participations.length + 1
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

  def net_paid
    self.collective_amount_paid - self.collective_amount_refunded
  end

  def close
    self.status = "closed"
    self.disburse_funds
  end

  def disburse_funds

    transfer = Stripe::Transfer.create(
      {
        :amount => self.current_balance,
        :currency => "usd",
        :method => "instant",
        :destination => "default_for_currency"
      },
      {:stripe_account => self.treasurer.merchant_account_id}
    )

    self.transfers.push(transfer.id)
    self.save

  end

  def distribute_surplus

    surplus = self.collective_amount_paid - (self.cost * 10)

    if surplus > 0
      self.season_participations.each do |participation|

        net_paid = 0

        if participation.amount_refunded == nil
          net_paid = participation.amount_paid
        else
          net_paid = participation.amount_paid - participation.amount_refunded
        end

        refund_amount = (net_paid - self.new_player_cost).to_i
        refund_response = participation.person.refund(participation.transactions[0], refund_amount)

      end

      return { message: "Surplus distributed" }
    else
      return { message: "There is no surplus" }
    end

  end

  def collective_amount_paid
    season_paid_amount = 0
    self.season_participations.each do |participation|
      season_paid_amount += (participation.amount_paid)
    end
    return season_paid_amount.to_i
  end

  def collective_amount_refunded
    season_refunded_amount = 0
    self.season_participations.each do |participation|
      if participation.amount_refunded != nil
        season_refunded_amount += (participation.amount_refunded)
      end
    end
    return season_refunded_amount.to_i
  end

  def disbursed_amount
    amount_disbursed = 0

    self.transfers.each do |transfer_id|
      transfer = Stripe::Transfer.retrieve(transfer_id, {stripe_account: self.treasurer.merchant_account_id})

      net_transferred = transfer.amount - transfer.amount_reversed
      amount_disbursed += net_transferred
    end

    return amount_disbursed

  end

  def current_balance
    balance = self.net_paid - self.disbursed_amount
    return balance
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
      self.min_players = 0
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

  def archive
    self.status = "archived"
  end

end
