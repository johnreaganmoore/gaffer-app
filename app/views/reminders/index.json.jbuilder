json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :references, :label, :next_date, :interval
  json.url reminder_url(reminder, format: :json)
end
