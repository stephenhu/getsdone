class Action < ActiveRecord::Base

  has_many :hashtags
  has_many :tags, :through => :hashtags

  belongs_to :user

end

