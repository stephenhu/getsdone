module Getsdone

  module AppHelper

    def self.time_ago_in_web(seconds)

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

      if delta > 0
        return time_ago_in_web(delta)
      else
        return "overdue"
      end

    end


    def self.get_action_info(actions)

      t = Time.now

      today     = 0
      week      = 0
      overdue   = 0

      today_begin = t.beginning_of_day
      today_end   = t.end_of_day

      week_begin  = t.beginning_of_week
      week_end    = t.end_of_week

      actions.each do |a|

        if a.estimate >= today_begin and a.estimate <= today_end
          today = today + 1
        end

        if a.estimate < today_end
          overdue = overdue + 1
        end

        if a.estimate >= week_begin and a.estimate <= week_end
          week = week + 1
        end

      end

      return { :today => today, :week => week, :overdue => overdue }

    end

    def self.get_user_info(user)

      completed = user.actions.where( :completed => true ).count

      followers = user.followers.length
      following = user.following.length

      return { :completed => completed, :followers => followers,
        :following => following }

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

    def self.add_action( params, user )

      if user[:name].nil?
        return false
      end

      u = User.find_by_name(user[:name])

      Action.transaction do

        a = u.actions.create(
          :action => params["action"],
          :priority => params["priority"] )

        a.save

        unless params["hashtag"].nil?
 
          a.tags.create(
            :tag => params["hashtag"] )

          a.save

        end
      
        owner = params["owner"]

        o = User.find_by_name(owner) unless owner.nil?

        
        if o.nil?
          id = u.id
        else
          id = o.id
        end

        a.delegates.create(
          :user_id => id )

        a.save

      end
     
      return true
 
    end

  end

end

