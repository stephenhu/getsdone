# encoding: UTF-8

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
        "../config/database.yml" ) )[env]

      config    = YAML.load_file(File.join( Sinatra::Application.root,
        "../config/config.yml" ) )

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :database,          database
      set :config,            config

      cipher = OpenSSL::Cipher::AES.new( 128, :CBC )
      cipher.encrypt

      cipher.key  = config["app"]["key"]
      cipher.iv   = config["app"]["iv"]

      decipher = OpenSSL::Cipher::AES.new( 128, :CBC )
      decipher.decrypt

      decipher.key = config["app"]["key"]
      decipher.iv  = config["app"]["iv"]
      
      set :cipher,            cipher
      set :decipher,          decipher
 
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

        settings.decipher.reset

        decoded = Base64.decode64(token)
        plain   = settings.decipher.update(decoded) + settings.decipher.final

        return User.find_by_uuid(plain)

      end

    end

    def create_token(uuid)

      settings.cipher.reset

      token   = settings.cipher.update(uuid) + settings.cipher.final
      encoded = Base64.encode64(token)

      response.set_cookie( "getsdone", { :value => encoded, :path => "/" } )

    end

  end

end

