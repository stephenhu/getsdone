module Getsdone 

  class Api < App

    get "/version" do
      return VERSION
    end

#TODO: api key
    post "/actions" do

      authenticate

      unless AppHelper.validate(params)
        return { :status => "400",
                 :msg => "Bad parameters" }.to_json
      end

      unless AppHelper.add_action( params, session[:user] )
        return { :status => "401",
                 :msg => "User not found" }.to_json
      end

      return { :status => "200",
               :msg => "" }.to_json

    end

    put "/actions/:id" do

      authenticate

      a = Action.find_by_id(params[:id])

      if a.nil?

        return { :status => "404",
                 :msg => "Action not found" }.to_json

      end

      Action.transaction do

        a.completed = true

        a.finished = Time.now

        a.save

      end 
      
    end

    delete "/actions/:id" do

      authenticate

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

    post "/user/:id?:verb?" do

      # make sure user exists
      # make sure not following
      puts params[:id]
      puts params[:verb]
      puts "line break"
      u = User.find_by_id(session[:user][:id])

      unless u.is_following(params[:id])
        u.add_follower(params[:id])
      end

    end

  end

end

