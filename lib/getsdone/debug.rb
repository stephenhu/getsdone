module Getsdone 

  class Debug < App

    get "/actions" do

      @nohead = true
      @nofoot = true

      u = User.find_by_id(session[:user][:id])

      @user = u

      @actions = u.actions

      haml :test

    end

    get "/fakelogin/:id" do

      u = User.find_by_id(params[:id])

      session[:user]         = u
      session[:user][:id]    = u.id
      session[:user][:name]  = u.name

    end

  end

end

