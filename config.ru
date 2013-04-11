require File.join( File.dirname(__FILE__), "lib", "getsdone" )

map "/" do
  run Getsdone::Web
end

map "/api" do
  run Getsdone::Api
end

map "/auth" do
  run Getsdone::Auth
end

if ENV["RACK_ENV"] == "development"

  map "/debug" do
    run Getsdone::Debug
  end

end

