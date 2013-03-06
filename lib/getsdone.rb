require "active_record"
require "haml"
require "json"
require "sinatra"
require "sqlite3"
require "thin"

require File.join( File.dirname(__FILE__), "getsdone", "server_helper" )
require File.join( File.dirname(__FILE__), "getsdone", "server" )
require File.join( File.dirname(__FILE__), "getsdone", "version" )

Dir.glob("./getsdone/models/*").each {|r| require r }

module Getsdone

  configure do

    env = ENV["RACK_ENV"] || "development"

    config = YAML.load_file(File.join( Sinatra::Application.root,
      "../conf/database.yml" ) )[env]

    set :views,    File.join( Sinatra::Application.root, "views" )
    set :config,   config

    ActiveRecord::Base.establish_connection config

  end

end

