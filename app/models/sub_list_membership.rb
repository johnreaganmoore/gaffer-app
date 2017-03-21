class SubListMembership < ApplicationRecord
  belongs_to :sub_list
  belongs_to :person
end
