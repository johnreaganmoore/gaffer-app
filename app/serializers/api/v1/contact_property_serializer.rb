class Api::V1::ContactPropertySerializer < ActiveModel::Serializer
  attributes :id, :type, :key, :required



  def type
    case object.data_type
    when "text"
      return "unicode"
    when "number"
      return "float"
    when "date"
      return "DateTime"
    end
  end

  def key
    return object.property
  end

  def required
    "false"
  end


  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end

# {
# "type": "unicode",
# "key": "json_key", // the field "name", will be used to construct a label if none is provided
# "required": false, // whether this field must be filled out. defaults to true
# "label": "Pretty Label", // optional
# "help_text": "Helps to explain things to users.", // optional
# "choices": { // optional
#     "raw": "label"
# } // can also be a flat array if raw is the label
# "prefill": "contact.id.name", // optional, defines a dynamic dropdown
# "searchfill": "contact.id" // optional, defines a search connector
# }
