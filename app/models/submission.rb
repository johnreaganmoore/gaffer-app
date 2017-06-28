class Submission < ApplicationRecord
  belongs_to :org

  has_many :submission_values, inverse_of: :submission, dependent: :destroy
  accepts_nested_attributes_for :submission_values
  after_update :notify_zapier

  def iframely(property)

    key = ENV['iframely_api_key']

    response = HTTParty.get("http://iframe.ly/api/iframely?url=#{property}&api_key=#{key}")
    if response.code == 200
      return response.parsed_response["html"].html_safe
    else
      return false
    end
  end

  def embed
    self.submission_values.each do |value|
      result = self.iframely(value.display_value)
      return result
    end
  end

  def notify_zapier

    body = Api::V1::SubmissionSerializer.new(self).to_json
    headers = {
      "Content-Type": "application/json"
    }
    admins = self.org.admins

    hooks = []

    admins.each do |admin|

      hook = Hook.find_by(person_id: admin.id)

      if hook
        hooks << hook
      end

    end

    hooks.each do |hook|
      response = HTTParty.post(
        hook.target_url, { body: body, headers: headers }
      )
      puts response.inspect
    end

  end
end
