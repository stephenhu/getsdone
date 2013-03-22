module Getsdone

  module AppHelper

    def self.duration_calc(estimate)

      now = Time.now

      delta = estimate - now
      puts delta

      if delta > 0
# get largest denominator
        puts time_ago_in_words(estimate)
        return "10"
      else
        return "0"
      end

    end

    def self.validate(params)

      params.each do |k,v|

        if v == ""
          params[k] = nil
        else
          params[k] = v.strip
        end
          
      end

    end

    def self.decode_token(token)

      if token.nil?
        return nil
      else
        return User.find_by_token(Base64.decode64(token))
      end

    end

    def self.check_token

      token = request.cookies["getsdone"]

      user = decode_token(token)

      user.nil? ? @logged = false : @logged = true

      return user
 
    end

    def self.add_action(params)

# check owner
      u = User.find_by_name(params["owner"])

      if u.nil?
        halt 400, "User not found."
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

