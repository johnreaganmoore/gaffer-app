class ContactValue < ApplicationRecord
  belongs_to :contact, inverse_of: :contact_values
  belongs_to :contact_property, touch: true

  def display_value
    if self.contact_property.data_type == "number"
      return self.number_value
    elsif self.contact_property.data_type == "date" && self.date_value
      return self.date_value.strftime("%m/%d/%Y")
    else
      return self.value
    end
  end

end
