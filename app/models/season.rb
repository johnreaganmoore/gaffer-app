class Season < ApplicationRecord
  belongs_to :team
  has_many :season_participations
  has_many :people, through: :season_participations
end
