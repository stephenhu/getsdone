require "active_record"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/time/calculations"
require "base64"
require "haml"
require "json"
require "oauth2"
require "rest_client"
require "sinatra"
#require "sinatra/cookies"
require "sqlite3"
require "thin"
require "time"

require File.join( File.dirname(__FILE__), "getsdone", "app_helper" )
require File.join( File.dirname(__FILE__), "getsdone", "app" )
require File.join( File.dirname(__FILE__), "getsdone", "api" )
require File.join( File.dirname(__FILE__), "getsdone", "auth" )
require File.join( File.dirname(__FILE__), "getsdone", "google_helper" )
require File.join( File.dirname(__FILE__), "getsdone", "version" )
require File.join( File.dirname(__FILE__), "getsdone", "web" )

if ENV["RACK_ENV"] == "development"
  require File.join( File.dirname(__FILE__), "getsdone", "debug" )
end

Dir.glob("./getsdone/models/*").each {|r| require r }

module Getsdone

#  SCOPE           = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
  SCOPE           = "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email"
  AUTH_ENDPOINT   = "https://accounts.google.com"
  AUTH_RESOURCE   = "/o/oauth2/auth"
  TOKEN_RESOURCE  = "/o/oauth2/token"
  REDIRECT_URI    = "http://localhost:9292/auth/oauth2callback"
  GOOGLE_EMAIL    = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json"

  UPCOMING        = 3

end

