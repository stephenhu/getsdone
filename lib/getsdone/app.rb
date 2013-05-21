module Getsdone 

  class App < Sinatra::Base
    #use Rack::SslEnforcer, :except_environments => "development"

    use Rack::SslEnforcer if ENV["RACK_ENV"] == "production"

    enable :logging

    configure do

      env     = ENV["RACK_ENV"] || "development"
      #secret  = ENV["RACK_SECRET"] || "stephen the great"

      config = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/database.yml" ) )[env]

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :config,            config
      #set :session_secret,    secret

      Dir.mkdir("logs") unless File.exist?("logs")

      logger = Logger.new("logs/getsdone.log")

      logger.level = Logger::INFO

      if ENV["RACK_ENV"] == "production"

        STDOUT.reopen( "logs/verbose.log", "w" )
        STDOUT.sync = true

        STDERR.reopen(STDOUT)

      end

      ActiveRecord::Base.logger = Logger.new("logs/db.log")
      ActiveRecord::Base.establish_connection config

    end

    def check_token

      token = request.cookies["getsdone"]

      if token.nil?
        return nil
      else
        return User.find_by_uuid(token)
      end

    end

    def authenticate
      return check_token
    end

  end

end

