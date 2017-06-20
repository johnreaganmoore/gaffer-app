class Api::V1::ContactPropertiesController < Api::V1::BaseController
  include ActiveHashRelation

  def index
    @active_org = current_person.administered_orgs[0]

    @contact_properties = @active_org.contact_properties

    serialized_array = []

    @contact_properties.each do |con|
      serialized_array.push(Api::V1::ContactPropertySerializer.new(con))
    end

    render json: serialized_array.to_json

  end

end
