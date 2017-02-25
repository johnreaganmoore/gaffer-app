class League < ApplicationRecord
  belongs_to :org
  has_many :seasons

  def locations
    locations = []
    self.seasons.each do |season|
      locations.push(season.location) unless locations.include? season.location
    end

    return locations
  end
end
