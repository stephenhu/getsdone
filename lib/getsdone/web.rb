module Getsdone 

  class Web < App

    not_found do
      @nohead = true
      haml :error
    end

    get "/" do
      @nohead = true
      haml :index
    end

    get "/user/:id" do

      @nohead  = true
      @user    = User.find_by_id(session[:user][:id]) 
      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      if @profile.nil?
        halt 404, "User not found"
      end

      haml :user

    end

    get "/user/:id/following" do

      @nohead = true

      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      haml :following

    end

    get "/user/:id/followers" do

      @nohead = true

      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      haml :followers

    end

    get "/home" do

      #authenticate

      @view = params[:view]
 
      u = User.find_by_id(session[:user][:id])

      @user = u
      @info = @user.info

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
        @view = "open"
        @actions = u.open_actions
      end

      haml :home

    end

    get "/history" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      @user = u
      @view = "history"

      @actions = u.completed_actions

      haml :history
    end

    get "/statistics" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      @user = u
      @view = "statistics"

      haml :statistics

    end

    get "/login" do
      haml :login
    end

  end

end

