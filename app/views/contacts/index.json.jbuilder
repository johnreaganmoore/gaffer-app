json.array!(@contacts) do |contact|
  json.extract! contact, :id, :references, :first_name, :last_name, :phone, :email
  json.url contact_url(contact, format: :json)
end
