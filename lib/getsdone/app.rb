module Getsdone 

  class App < Sinatra::Base

    configure do

      env = ENV["RACK_ENV"] || "development"
 
      config = YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/database.yml" ) )[env]

      set :public_folder,     File.join( Sinatra::Application.root, "/public" )
      set :views,             File.join( Sinatra::Application.root, "/views" )
      set :config,            config
 
      ActiveRecord::Base.establish_connection config
 
    end

  end

end

