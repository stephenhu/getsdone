require "./getsdone"

map "/" do
  run Getsdone::Web
end

map "/api" do
  run Getsdone::Api
end

map "/auth" do
  run Getsdone::Auth
end

