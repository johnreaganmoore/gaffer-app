json.array!(@notes) do |note|
  json.extract! note, :id, :references, :body
  json.url note_url(note, format: :json)
end
