class ContactProperty < ApplicationRecord
  belongs_to :org
  has_many :contact_values
end
