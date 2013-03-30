require "digest/md5"
require "securerandom"

class Delegate < ActiveRecord::Base

  belongs_to :action


end

