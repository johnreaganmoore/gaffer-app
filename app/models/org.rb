class Org < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :leagues
end
