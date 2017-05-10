class ContactProperty < ApplicationRecord
  belongs_to :org
  has_many :contact_values, dependent: :destroy

  after_create :set_defaults_on_existing_contacts

  def set_defaults_on_existing_contacts
    self.org.contacts.each do |contact|
      ContactValue.create(contact: contact, contact_property: self)
    end
  end

end
