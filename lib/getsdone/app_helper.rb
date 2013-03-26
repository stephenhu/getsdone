module Getsdone

  module AppHelper

    def self.time_ago_in_web(seconds)

      puts seconds

      seconds_in_day 	= 24 * 60 * 60
      seconds_in_hours	= 60 * 60
      seconds_in_mins	= 60

      days = seconds / seconds_in_day

      if days > 1
        return "#{days.truncate}d"
      end

      hours = seconds / seconds_in_hours

      if hours < 24 and hours > 0
        return "#{hours.truncate}h"
      end

      mins  = seconds / seconds_in_mins

      if mins > 0 and mins < 60
        return "#{mins.truncate}m"
      end

    end

    def self.duration_calc(estimate)

      now = Time.now

      delta = estimate - now
      puts delta

      if delta > 0
# get largest denominator
        return time_ago_in_web(delta)
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

        case k
        when "action"
          return false if v.empty?
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
        return false
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
     
      return true
 
    end

  end

end

