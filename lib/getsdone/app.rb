module Getsdone 

  class App < Sinatra::Base

    enable :sessions

    configure do

      env = ENV["RACK_ENV"] || "development"

      config = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/database.yml" ) )[env]

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :config,            config
      set :session_secret,    "stephen the great"
 
      ActiveRecord::Base.establish_connection config
 
    end

    def check_token

      token = request.cookies["getsdone.io"]

      if token.nil?
        session[:user] = nil
      else

        u = User.find_by_token(Base64.decode64(token))
        session[:user] = u.id

      end

    end

    def authenticate

      if session[:user].nil?
  
        check_token

        redirect "/login" if session[:user].nil?
        
      else
        redirect "/login"
      end
     
    end

  end

end

