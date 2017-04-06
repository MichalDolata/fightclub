json.extract! tournament, :id, :name, :start_date, :teams, :creator_id, :started, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
