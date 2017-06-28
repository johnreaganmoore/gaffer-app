class Api::V1::SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone, :first_name, :last_name, :status, :created_at, :updated_at, :submission_values

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
