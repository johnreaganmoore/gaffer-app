class Note < ApplicationRecord
  belongs_to :contact, touch: true

  belongs_to :person, :foreign_key => 'creator_id'

  def creator
    Person.find(self.creator_id)
  end


end
