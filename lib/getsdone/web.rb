module Getsdone 

  class Web < App

    not_found do
      @nohead = true
      @title  = "getsdone.io - page not found"
      haml :error
    end

    get "/" do
      @nohead = true
      @title  = "getsdone.io - getting things done socially"
      haml :index
    end

    get "/blog" do

      @nohead = true
      @title  = "getsdone.io - blog"
      haml :blog

    end
    get "/company" do

      @nohead = true
      @title  = "getsdone.io - company"
      haml :company

    end

    get "/about" do

      @nohead = true
      @title  = "getsdone.io - about"
      haml :about

    end

    get "/terms" do

      @nohead = true
      @title  = "getsdone.io - terms of service"
      haml :terms

    end

    get "/privacy" do

      @nohead = true
      @title  = "getsdone.io - privacy"
      haml :privacy

    end

    get "/users/:id" do

      @nohead  = true
      @title  = "getsdone.io - user"
      @user    = User.find_by_uuid(session[:getsdone]) 
      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      if @profile.nil?
        halt 404, "User not found"
      end

      haml :user

    end

    get "/users/:id/following" do

      @nohead = true
      @title  = "getsdone.io - following"

      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      haml :following

    end

    get "/users/:id/followers" do

      @nohead = true
      @title  = "getsdone.io - followers"

      @profile = User.find_by_name(params[:id])
      @info    = @profile.info

      haml :followers

    end

    get "/home" do

      u = authenticate

      redirect "/login" if u.nil?

      @title  = "getsdone.io - home"
      @view = params[:view]
 
      @user = u
      @info = @user.info
      @who  = "owner"

      if @view == "week"
        @actions = u.weeks_actions
      elsif @view == "upcoming"
        @actions = u.overdue_actions + u.upcoming_actions
      elsif @view == "open"
        @actions = u.open_actions
      elsif @view == "assigned"
        @actions = u.assigned_actions
        @who     = "delegate"
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

      u = authenticate

      redirect "/login" if u.nil?

      @title  = "getsdone.io - hashtags"

      @nohead   = true
      @user     = u
      @info     = @user.info

      @hashtag  = params[:hashtag]
      @actions  = AppHelper.get_hashtag_actions(params[:hashtag])

      haml :hashtags

    end

    get "/history" do

      u = authenticate

      redirect "/login" if u.nil?

      @title  = "getsdone.io - history"

      @user = u
      @view = "history"
      @info = u.info

      @actions = u.completed_actions

      haml :history
    end

    get "/statistics" do

      u = authenticate

      redirect "/login" if u.nil?

      @title  = "getsdone.io - statistics"

      @user     = u
      @view     = "statistics"
      @info     = u.info

      haml :statistics

    end

    get "/login" do

      @title  = "getsdone.io - login"
      @nohead = true

      haml :login

    end

    get "/signup" do

      @title    = "getsdone.io - signup"
      @nohead   = true

      haml :signup

    end

    get "/forgot" do

      @title    = "getsdone.io - forgot"
      @nohead   = true

      haml :forgot

    end

  end

end

