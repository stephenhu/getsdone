class Hashtag < ActiveRecord::Base

  belongs_to :action
  belongs_to :tag

end

