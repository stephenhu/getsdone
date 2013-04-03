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

      u = User.find_by_id(user[:id])

      if u.nil?
        return false
      end

      Action.transaction do

        a = u.actions.create(
          :action => params["action"],
          :priority => params["priority"] )

        a.save

        unless params["hashtag"].nil?

          t = Tag.find_by_tag(params["hashtag"])

          if t.nil?

            a.tags.create(
              :tag => params["hashtag"] )

            a.save

          else

            a.hashtags.create( :tag_id => t.id )

          end

        end
      
        owner = params["owner"]

        o = User.find_by_name(owner) unless owner.nil?

        
        if o.nil?
          id = u.id
        else
          id = o.id
        end

        a.create_delegate( :user_id => id )

        a.save

      end
     
      return true
 
    end

    def self.get_hashtags(actions)

      hashtags = []

      actions.each do |a|

        a.tags.each do |t|
          hashtags.append(t.tag)
        end

      end

      return hashtags.uniq

    end

    def self.get_hashtag_actions(hashtag)

      tag_id = Tag.joins(:hashtags).where( :tag => hashtag ).first()

      t = Action.joins(:hashtags).where( "hashtags.tag_id" => tag_id.id,
        :completed => false )

      return t

    end

  end

end

