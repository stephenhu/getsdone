module Getsdone

  helpers do

    def decode_token(token)

      if token.nil?
        return nil
      else
        return User.find_by_token(Base64.decode64(token))
      end

    end

    def check_token

      token = request.cookies["getsdone"]

      user = decode_token(token)

      user.nil? ? @logged = false : @logged = true

      return user
 
    end

    def add_action(params)

# check owner
      u = User.find_by_name(params["owner"].strip)

      if u.nil?
        halt 400, "User not found."
      end

      Action.transaction do

        a = Action.create(
          :user_id => 1,
          :delegate_id => 1,
          :action => params["action"].strip,
          :priority => params["priority"].strip )

        a.save

        unless params["hashtag"].nil?
 
          a.tags.create(
            :tag => params["hashtag"].strip )

          a.save

        end

      end
      
    end

  end

end

