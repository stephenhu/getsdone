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

    get "/blog" do

      @nohead = true
      haml :blog

    end
    get "/company" do

      @nohead = true
      haml :company

    end

    get "/about" do

      @nohead = true
      haml :about

    end

    get "/terms" do

      @nohead = true
      haml :terms

    end

    get "/privacy" do

      @nohead = true
      haml :privacy

    end

    get "/users/:id" do

      @nohead  = true
      @user    = User.find_by_id(session[:user][:id]) 
      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      if @profile.nil?
        halt 404, "User not found"
      end

      haml :user

    end

    get "/users/:id/following" do

      @nohead = true

      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      haml :following

    end

    get "/users/:id/followers" do

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
      elsif @view == "assigned"
        @actions = u.assigned_actions
      elsif @view == "hashtags"
        @hashtags = AppHelper.get_hashtags(u.hashtag_actions)
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

    get "/hashtags/:hashtag" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      @nohead   = true
      @user     = u
      @info     = @user.info

      @hashtag  = params[:hashtag]
      @actions  = AppHelper.get_hashtag_actions(params[:hashtag])

      haml :hashtags

    end

    get "/history" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      @user = u
      @view = "history"
      @info = u.info

      @actions = u.completed_actions

      haml :history
    end

    get "/statistics" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      @user     = u
      @view     = "statistics"
      @info     = u.info

      haml :statistics

    end

    get "/login" do
      haml :login
    end

  end

end

