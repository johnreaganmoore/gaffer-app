class ContactValue < ApplicationRecord
  belongs_to :contact, inverse_of: :contact_values
  belongs_to :contact_property, touch: true
end
