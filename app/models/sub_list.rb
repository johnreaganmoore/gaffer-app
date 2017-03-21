class SubList < ApplicationRecord
  has_many :sub_list_memberships
  has_many :people, through: :sub_list_memberships
  belongs_to :org
end
