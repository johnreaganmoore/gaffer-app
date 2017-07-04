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
      if result
        return result
      end
    end

    false

  end

  def notify_zapier

    body_hash = self.attributes

    self.submission_values.each do |sv|
      body_hash["#{sv.contact_property.property}"] = sv.display_value
    end

    body = body_hash.to_json

    headers = {
      "Content-Type": "application/json"
    }
    admins = self.org.admins

    hooks = []

    puts body.inspect

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
    end

  end
end
