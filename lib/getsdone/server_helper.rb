module Getsdone

  helpers do

    def add_action(params)

# check owner
      u = User.find_by_name(params["owner"].strip)

      if u.nil?
        halt 400, "User not found.".to_json
      end

      Action.transaction do

        a = Action.create(
          :user_id => 1,
          :delegate_id => 1,
          :action => params["action"],
          :priority => params["priority"] )

        a.save

        unless params["hashtag"].nil?
 
          a.tags.create(
            :tag => params["hashtag"] )

          a.save

        end

      end
      
    end

  end

end

