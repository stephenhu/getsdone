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

        #if v == ""
        #  params[k] = nil
        #else
        #  params[k] = v.strip
        #end

        case k
        when "action"
          return false if v.empty?
        end

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
        :state => STATE[:open] )

      return t

    end

  end

end

