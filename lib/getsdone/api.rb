module Getsdone 

  class Api < App

    get "/version" do
      return VERSION
    end

#TODO: api key
    post "/actions" do

      #authenticate
      u = User.find_by_id(session[:user][:id])

      unless AppHelper.validate(params)
        return { :status => "400",
                 :msg => "Bad parameters" }.to_json
      end

      unless u.add_actions(params)
        return { :status => "500", :msg => "Unable to add action" }.to_json
      end

      return { :status => "200", :msg => "" }.to_json

    end

    put "/actions/:id" do

      #authenticate

      a = Action.find_by_id(params[:id])

      if a.nil?

        return { :status => "404", :msg => "Action not found" }.to_json

      end

      Action.transaction do

        a.state = STATE[:closed]

        a.finished = Time.now

        a.save

      end 
      
    end

    delete "/actions/:id" do

      #authenticate

      a = Action.find_by_id(params[:id])

      if a.nil?

        return { :status => "404",
                 :msg => "Action not found" }.to_json

      end

      if a.user_id != session[:user][:id]

        return { :status => "403",
                 :msg => "You don't own this action" }.to_json

      end

      if a.nil?

        return { :status => "404",
                 :msg => "Action not found" }.to_json

      else

        Action.destroy(params[:id])

      end

      return { :status => "200",
               :msg => "" }.to_json

    end

    post "/actions/:id/comments" do

      #authenticate
      u = User.find_by_id(session[:user][:id])

      a = Action.find_by_id(params[:id])

      if a.nil?

        return { :status => "401",
                 :msg => "Action not found" }.to_json

      else

        c = a.comments.create( :user_id => u.id, :comment => params[:comment] )

        return { :status => "200",
                 :msg => c }.to_json
      end

    end

    put "/users/:id/followers" do

      #authenticate

      # make sure user exists
      # make sure not following
      u = User.find_by_id(session[:user][:id])

      u.add_follower(params[:id])

      return { :status => "200", :msg => "" }.to_json

    end

    delete "/users/:id/followers" do

      #authenticate

      u = User.find_by_id(session[:user][:id])

      u.remove_follower(params[:id])

      return { :status => "200", :msg => "" }.to_json

    end

  end

end

