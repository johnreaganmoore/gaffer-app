class PlayingTime < ApplicationRecord
  belongs_to :timeframe
  belongs_to :season
end
