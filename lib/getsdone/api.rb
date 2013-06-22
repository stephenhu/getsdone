module Getsdone 

  class Api < App

    get "/version" do
      return VERSION
    end

    post "/actions" do

      u = authenticate

      if u.nil?
        return { :status => "403", :msg => "requires login" }.to_json
      end

      unless AppHelper.validate(params)
        return { :status => "400",
                 :msg => "Bad parameters" }.to_json
      end

      res = u.add_actions(params)

      if res
        return { :msg => "action added" }.to_json
        #halt 500, {:msg => "unable to add action"}.to_json
      else
        halt 500, {:msg => "unable to add action"}.to_json
      end


    end

    put "/actions/:id" do

      u = authenticate

      redirect "/login" if u.nil?

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

      u = authenticate

      redirect "/login" if u.nil?

      a = Action.find_by_id(params[:id])

      if a.nil?

        return { :status => "404",
                 :msg => "Action not found" }.to_json

      end

      if a.user_id != u.id

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

      u = authenticate

      redirect "/login" if u.nil?

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

    post "/users" do

      u = User.find_by_name(params[:name])

      if u.nil?

        user = User.create(
          :name => params[:name].downcase,
          :uuid => params[:email].downcase,
          :password => params[:password] )

        user.save

        return { :status => "200",
                 :msg => "success" }.to_json

      else

        halt 403, { :msg => "username taken" }.to_json

      end

    end

    put "/users/:id/followers" do

      u = authenticate

      redirect "/login" if u.nil?

      # make sure user exists
      # make sure not following

      u.add_follower(params[:id])

      return { :status => "200", :msg => "" }.to_json

    end

    delete "/users/:id/followers" do

      u = authenticate

      redirect "/login" if u.nil?

      u.remove_follower(params[:id])

      return { :status => "200", :msg => "" }.to_json

    end

  end

end

