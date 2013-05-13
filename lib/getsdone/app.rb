module Getsdone 

  class App < Sinatra::Base

    enable :sessions

    configure do

      env     = ENV["RACK_ENV"] || "development"
      secret  = ENV["RACK_SECRET"] || "stephen the great"

      config = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/database.yml" ) )[env]

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :config,            config
      set :session_secret,    secret
 
      ActiveRecord::Base.establish_connection config
 
    end

    def check_token

      token = session[:getsdone]

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

