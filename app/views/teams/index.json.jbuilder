json.array!(@teams) do |team|
  json.extract! team, :id, :name, :color, :logo
  json.url team_url(team, format: :json)
end
