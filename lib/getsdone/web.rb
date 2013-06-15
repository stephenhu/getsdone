module Getsdone 

  class Web < App

    before do

      u = authenticate
     
      if u.nil?
        @user = nil
      else
        @user = u
      end

    end

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

    get "/help" do

      @nohead = true
      @title = "getsdone.io - help"
      haml :help

    end

    get "/users/:id" do

      @nohead  = true
      @title   = "getsdone.io - user"
      @profile = User.find_by_name(params[:id])

      if @profile.nil?
        halt 404, "User not found"
      end

      @info    = @profile.info

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

      redirect "/login" if @user.nil?

      @title  = "getsdone.io - home"
      @view = params[:view]
 
      @info = @user.info
      @who  = "owner"

      if @view == "week"
        @actions = @user.weeks_actions
      elsif @view == "upcoming"
        @actions = @user.overdue_actions + @user.upcoming_actions
      elsif @view == "open"
        @actions = @user.open_actions
      elsif @view == "assigned"
        @actions = @user.assigned_actions
        @who     = "delegate"
      elsif @view == "hashtags"
        @hashtags = AppHelper.get_hashtags(@user.hashtag_actions)
      elsif @view == "history"
        redirect "/history"
      elsif @view == "statistics"
        redirect "/statistics"
      else
        @view = "open"
        @actions = @user.open_actions
      end

      haml :home

    end

    get "/hashtags/:hashtag" do

      redirect "/login" if @user.nil?

      @title  = "getsdone.io - hashtags"

      @nohead   = true
      @info     = @user.info

      @hashtag  = params[:hashtag]
      @actions  = AppHelper.get_hashtag_actions(params[:hashtag])

      haml :hashtags

    end

    get "/history" do

      redirect "/login" if @user.nil?

      @title  = "getsdone.io - history"

      @view = "history"
      @info = @user.info

      @actions = @user.completed_actions

      haml :history

    end

    get "/statistics" do

      redirect "/login" if @user.nil?

      @title  = "getsdone.io - statistics"

      @view     = "statistics"
      @info     = @user.info

      haml :statistics

    end

    get "/login" do

      redirect "/home" unless @user.nil?

      @title  = "getsdone.io - login"
      @nohead = true
      @loginpage = "login"

      haml :login

    end

    get "/signup" do

      redirect "/home" unless @user.nil?

      @title    = "getsdone.io - signup"
      @nohead   = true

      haml :signup

    end

    get "/forgot" do

      redirect "/home" unless @user.nil?

      @title    = "getsdone.io - forgot"
      @nohead   = true

      haml :forgot

    end

  end

end

