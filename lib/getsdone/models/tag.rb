class Tag < ActiveRecord::Base

  has_many :hashtags
  has_many :actions, :through => :hashtags

end

