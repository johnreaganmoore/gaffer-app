class Api::V1::ContactSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone, :first_name, :last_name, :created_at, :updated_at

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
