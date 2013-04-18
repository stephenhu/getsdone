module Getsdone

  class Comment < ActiveRecord::Base
  
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
  
  end

end
