module Getsdone

  module AppHelper

    def self.time_ago_in_web(seconds)

      seconds_in_day 	  = 24 * 60 * 60
      seconds_in_hours	= 60 * 60
      seconds_in_mins	  = 60

      days = (seconds / seconds_in_day).to_i

      if days >= 1
        return "#{days.truncate}d"
      end

      hours = (seconds / seconds_in_hours).to_i

      if hours < 24 and hours > 0
        return "#{hours.truncate}h"
      end

      mins  = (seconds / seconds_in_mins).to_i

      if mins > 0 and mins <= 60
        return "#{mins.truncate}m"
      end

      return "#{seconds.to_i.truncate}s"
 
    end

    def self.duration_calc(t1)

      now = Time.now

      delta = now - t1

      #wtime = time_ago_in_web(delta.abs)

      #if delta > 0
      #  return wtime
      #else
      #  return "#{wtime} overdue"
      #end

      wtime = time_ago_in_web(delta)

      return "#{wtime}"

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

      if tag_id.nil?
        return false
      end

      t = Action.joins(:hashtags).where( "hashtags.tag_id" => tag_id.id,
        :state => STATE[:open] )

      return t

    end

  end

end

