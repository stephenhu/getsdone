module Getsdone 

  class Debug < App

    get "/actions" do

      @nohead = true
      @nofoot = true

      u = User.find_by_uuid(session[:getsdone])

      @user = u

      @actions = u.actions

      haml :test

    end

    get "/fakelogin/:id" do

      u = User.find_by_id(params[:id])

      session[:getsdone] = u.uuid

    end

  end

end

