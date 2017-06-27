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

  def notify_zapier

    body = {
      submission: self.id,
      status: self.status
    }.to_json

    headers = {
      'Content-Type': 'application/json'
    }

    admins = self.org.admins

    hooks = []
    admins.each.do |admin|
      hook = Hook.find_by(person_id: admin.id)
      hooks << hooks
    end

    hooks.each.do |hook|
      response = HTTParty.post(
        hook.target_url,
        body,
        headers
      )
      puts response.inspect
    end
  end


end
