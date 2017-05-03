class Note < ApplicationRecord
  belongs_to :contact, touch: true
end
