module Getsdone

  class Action < ActiveRecord::Base
    include Twitter::Autolink

    has_many :comments, :dependent => :destroy  
    has_many :hashtags, :dependent => :destroy
    has_many :tags, :through => :hashtags
    has_one :delegate, :dependent => :destroy
  
    belongs_to :user
  
    after_create :set_estimate
  
    def set_estimate
      self.estimate = self.created_at + self.duration.days.to_i
      self.save
    end

    def get_duration

      d = Getsdone::AppHelper.duration_calc( self.finished, self.created_at )

      return d

    end 

    def time_elapsed

      elapsed = Getsdone::AppHelper.duration_calc( Time.now, self.created_at )

      return elapsed

    end
 
    def time_remaining
  
      rem = Getsdone::AppHelper.duration_calc( Time.now, self.estimate )
  
      return rem
  
    end
  
    def get_assigner_profile
  
      u = User.find_by_id(self.user_id)
      return u.profile
  
    end
  
    def get_delegate_profile
      u = User.find_by_id(self.delegate.user_id)
      return u.profile
    end
  
    def encoded_action
  
      #e = self.action.gsub(
      #  /\B@{1}[a-zA-Z0-9]+/){|m| "<a href=\"/users/#{m.gsub(/^@/,'')}\">#{m}</a>"}
  
      #e = e.gsub(
      #  /\B\#{1}[a-zA-Z0-9]+/){|m| "<a href=\"/hashtags/#{m.gsub(/^#/,'')}\">#{m}</a>"}
  
      #return e
  
      options = {
        :username_url_base => Getsdone::DEFAULT_USERNAME_URL_BASE,
        :hashtag_url_base => Getsdone::DEFAULT_HASHTAG_URL_BASE,
        :username_include_symbol => "@" }
 
      if self.origin_id.nil? 
        return auto_link( self.action, options )
      else

        old = Action.find_by_id(self.origin_id)

        unless old.nil?
           return auto_link( get_origin_text, options )
          #return auto_link( self.action + " // " + old.action, options )
        end

      end
  
    end

    def get_origin_text

      all = Action.where( :series_id => self.series_id ).order(
        "created_at desc" )

      text = ""

      all.each do |a|

        if text.empty?
          text = text + a.action
        else
          text = text + " // " + a.action
        end
 
      end

      return text

    end

    def get_origin_comments

      if self.origin_id.nil?
        return self.comments.order("created_at DESC")
      else

        origin = Action.find_by_id(self.origin_id)

        return self.comments.order("created_at DESC") +
          origin.comments.order("created_at DESC")

      end

    end

    def get_origin_user_id

      if self.origin_id.nil?
        return self.user_id
      else

        a = Action.find_by_id(self.origin_id)

        if a.nil?
          return nil
        else
          return a.user_id
        end
          
      end

    end

  end

end

