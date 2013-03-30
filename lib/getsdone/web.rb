module Getsdone 

  class Web < App

    get "/" do
      haml :index
    end

    get "/user/:id" do

      @nohead = true
      puts params[:id]
      @user = User.find_by_name(params[:id])

      if @user.nil?
        halt 404, "User not found"
      end

      haml :user

    end

    get "/home" do

      authenticate

      u = User.find_by_id(session[:user][:id])

      @user    = u

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

