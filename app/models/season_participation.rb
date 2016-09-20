class SeasonParticipation < ApplicationRecord
  belongs_to :person
  belongs_to :season
end
