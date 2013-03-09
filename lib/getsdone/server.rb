module Getsdone 

  class Server

    get "/" do
      haml :index
    end

    get "/home" do

      @actions = Action.where(:user_id => 1)
      haml :home

    end

    get "/today" do
      haml :today
    end

    get "/today1" do
      haml :today1
    end

    get "/test" do
      haml :test
    end

    get "/test2" do
      puts Tag.inspect
      puts Action.inspect
      puts Hashtag.inspect
      user = User.find_by_id(1)
      puts user.actions
    end

    # restful api
#TODO: api_key
    post "/api/actions" do

#TODO: validation

      add_action(params)

      return "{ \"status\": 200, \"msg\": \"ok\" }"

    end

  end

end

