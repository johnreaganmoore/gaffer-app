class Org < ApplicationRecord
  # Set a slug to be used in the url based on the org name
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Enable setting rolify roles
  resourcify

  # Set Relationships
  has_many :leagues
end
