module Getsdone 

  class Web < App

    not_found do
      @nohead = true
      haml :error
    end

    get "/" do
      haml :index
    end

    get "/user/:id" do

      @nohead  = true
      @user    = User.find_by_id(1) 
      @profile = User.find_by_name(params[:id])

      if @profile.nil?
        halt 404, "User not found"
      end

      haml :user

    end

    get "/home" do

      authenticate

      @view = params[:view]

      u = User.find_by_id(session[:user][:id])

      @user = u

      if @view == "week"
        @actions = u.weeks_actions
      elsif @view == "upcoming"
        @actions = u.overdue_actions + u.upcoming_actions
      elsif @view == "open"
        @actions = u.open_actions
      elsif @view == "hashtags"
        @actions = u.hashtag_actions
      elsif @view == "assigned"
        @actions = u.assigned_actions
      elsif @view == "history"
        redirect "/history"
      elsif @view == "statistics"
        redirect "/statistics"
      else
        @actions = u.todays_actions
      end

      haml :home

    end

    get "/history" do

      authenticate

      u = User.find_by_id(session[:user][:id])

      @user = u
      @view = "history"

      @actions = u.completed_actions

      haml :history
    end

    get "/statistics" do

      authenticate

      u = User.find_by_id(session[:user][:id])

      @user = u
      @view = "statistics"

      haml :statistics

    end

    get "/login" do
      haml :login
    end

    get "/test" do

      return ""

    end

  end

end

