module Getsdone 

  class Web < App

    get "/" do
      haml :index
    end

    get "/home" do

      authenticate

      u = User.find_by_id(session[:user][:id])

      @actions = u.open_actions
      @stats   = AppHelper.get_action_info(u.open_actions)
      @info    = AppHelper.get_user_info(u)

      haml :home

    end

    get "/login" do
      haml :login
    end

    get "/test" do

      u = User.find_by_id(session[:user][:id])
      AppHelper.get_user_info(u)

      return ""

    end

  end

end

