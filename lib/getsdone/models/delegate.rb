module Getsdone

  class Delegate < ActiveRecord::Base
    belongs_to :action
  end

end
