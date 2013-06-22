module Getsdone

  class Follow < ActiveRecord::Base
  
    has_many :users
  
    def get_profile(id)
  
      u = User.find_by_id(id)
  
      return { :name => u.name, :icon => u.icon_url }
  
    end
  
  end

end
