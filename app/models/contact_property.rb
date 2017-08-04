class ContactProperty < ApplicationRecord
  belongs_to :org
  has_many :contact_values, dependent: :destroy

  after_create :set_defaults_on_existing_contacts
  after_create :titleize_property
  before_save :titleize_property, if: :property_changed?

  def set_defaults_on_existing_contacts
    self.org.contacts.each do |contact|
      ContactValue.create(contact: contact, contact_property: self)
    end
  end

  def titleize_property
    self.property = self.property.titleize
  end

  def high_value
    self.contact_values.maximum("number_value")
  end

  def low_value
    self.contact_values.minimum("number_value")
  end

end
