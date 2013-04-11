module Getsdone

  class Action < ActiveRecord::Base
    include Twitter::Autolink
  
    has_many :hashtags, :dependent => :destroy
    has_many :tags, :through => :hashtags
    has_one :delegate, :dependent => :destroy
  
    belongs_to :user
  
    after_create :set_estimate
  
    def set_estimate
      self.estimate = self.created_at + self.duration.days.to_i
      self.save
    end
  
    def time_remaining
  
      rem = Getsdone::AppHelper.duration_calc(self.estimate)
  
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
  
      return auto_link( self.action, options )
  
    end
  
  end

end
