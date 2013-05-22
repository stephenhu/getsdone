module Getsdone 

  class App < Sinatra::Base
    #use Rack::SslEnforcer, :except_environments => "development"
    include BCrypt
    use Rack::SslEnforcer if ENV["RACK_ENV"] == "production"

    enable :logging

    configure do

      env     = ENV["RACK_ENV"] || "development"
      #secret  = ENV["RACK_SECRET"] || "stephen the great"

      database  = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/database.yml" ) )[env]

      config    = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/config.yml" ) )

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :database,          database
      set :config,            config

      cipher = OpenSSL::Cipher::AES.new( 128, :CBC )
      cipher.encrypt

      cipher.key  = config["app"]["key"]
      cipher.iv   = config["app"]["iv"]

      set :cipher,            cipher
      set :ckey,              config["app"]["key"]
      set :civ,               config["app"]["iv"]
 
      Dir.mkdir("logs") unless File.exist?("logs")

      logger = Logger.new("logs/getsdone.log")

      logger.level = Logger::INFO

      if ENV["RACK_ENV"] == "production"

        STDOUT.reopen( "logs/verbose.log", "w" )
        STDOUT.sync = true

        STDERR.reopen(STDOUT)

      end

      ActiveRecord::Base.logger = Logger.new("logs/db.log")
      ActiveRecord::Base.establish_connection database

    end

    def authenticate

      token = request.cookies["getsdone"]

      if token.nil?
        return nil
      else

        decipher = OpenSSL::Cipher::AES.new( 128, :CBC )
        decipher.decrypt

        decipher.key  = settings.ckey
        decipher.iv   = settings.civ

        plain = decipher.update(token) + decipher.final

        hash = eval(plain)

        return User.find_by_uuid(hash[:uuid])

      end

    end

    def create_token(uuid)

      hash = { :uuid => uuid, :api_key => settings.config["api"]["key"] }

      return settings.cipher.update(hash.to_s) + settings.cipher.final

    end

  end

end

