class ActionHashtag < ActiveRecord::Base

  belongs_to :actions
  belongs_to :hashtags

end

