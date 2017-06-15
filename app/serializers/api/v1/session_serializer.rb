class Api::V1::SessionSerializer < ActiveModel::Serializer
  #just some basic attributes
  attributes :id, :email, :name, :admin, :token

  def token
    object.authentication_token
  end
end
