json.array!(@bugs) do |task|
  json.extract! bug, :summary, :priority
  json.url bug_url(bug, format: :json)
end
