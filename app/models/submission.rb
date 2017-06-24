class Submission < ApplicationRecord
  belongs_to :org

  has_many :submission_values, inverse_of: :submission, dependent: :destroy
  accepts_nested_attributes_for :submission_values


  def iframely(property)
    response = HTTParty.get("http://iframe.ly/api/iframely?url=#{property}&api_key=#{ENV['iframely_api_key']}")

    if response.code == 200
      return response.parsed_response["html"].html_safe
    else
      return false
    end

  end

  def embed
    self.submission_values.each do |value|
      result = self.iframely(value.display_value)
      if result
        return result
      end
    end

    return false

  end


end
