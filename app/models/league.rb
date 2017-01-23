class League < ApplicationRecord
  belongs_to :org
  has_many :seasons
end
