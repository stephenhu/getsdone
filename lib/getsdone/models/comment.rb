module Getsdone

  class Comment < ActiveRecord::Base
    include Twitter::Autolink  

    belongs_to :users
    belongs_to :actions

    def get_profile

      u = User.find_by_id(self.user_id)
      return u.profile

    end

    def time_remaining

      delta = Time.now - self.created_at

      return Getsdone::AppHelper.time_ago_in_web(delta)

    end

    def encoded_comment

      options = {
        :username_url_base => Getsdone::DEFAULT_USERNAME_URL_BASE,
        :username_include_symbol => "@",
        :suppress_lists => true }

      return auto_link_usernames_or_lists( self.comment, options )

    end
  
  end

end
