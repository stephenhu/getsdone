require "active_record"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/time/calculations"
require "base64"
require "bcrypt"
require "digest/md5"
require "haml"
require "json"
require "oauth2"
require "rack-ssl-enforcer"
require "rest_client"
require "securerandom"
require "sinatra"
#require "sinatra/cookies"
require "sqlite3"
require "thin"
require "time"
require "twitter-text"

#Dir.glob("./getsdone/models/*").each {|r| require r }

require File.join( File.dirname(__FILE__), "getsdone/models", "action" )
require File.join( File.dirname(__FILE__), "getsdone/models", "comment" )
require File.join( File.dirname(__FILE__), "getsdone/models", "delegate" )
require File.join( File.dirname(__FILE__), "getsdone/models", "follow" )
require File.join( File.dirname(__FILE__), "getsdone/models", "hashtag" )
require File.join( File.dirname(__FILE__), "getsdone/models", "tag" )
require File.join( File.dirname(__FILE__), "getsdone/models", "user" )

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


module Getsdone

#  SCOPE           = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
  SCOPE           =
    "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email".freeze
  AUTH_ENDPOINT   = "https://accounts.google.com".freeze
  AUTH_RESOURCE   = "/o/oauth2/auth".freeze
  TOKEN_RESOURCE  = "/o/oauth2/token".freeze
  REDIRECT_URI    = "http://localhost:9292/auth/oauth2callback".freeze
  GOOGLE_EMAIL    = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json".freeze

  DEFAULT_USERNAME_URL_BASE   = "http://192.168.174.135:9292/users/".freeze
  DEFAULT_HASHTAG_URL_BASE    = "http://192.168.174.135:9292/hashtags/".freeze

  ONE_WEEK        = 60 * 60 * 24 * 7
  UPCOMING        = 3

  STATE = {
    :open => 0,
    :closed => 1,
    :deleted => 2,
    :reassigned => 3 }

end

