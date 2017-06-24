class SubmissionValue < ApplicationRecord
  belongs_to :submission
  belongs_to :contact_property

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
