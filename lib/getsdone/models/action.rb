class Action < ActiveRecord::Base

  has_many :hashtags
  has_many :tags, :through => :hashtags

  belongs_to :user

  after_create :set_estimate

  def set_estimate
    self.estimate = self.created_at + self.duration.days.to_i
    self.save
  end

  def time_remaining

    rem = Getsdone::AppHelper.duration_calc(self.estimate)

    return rem
    #if now < self.estimate
  
    #  delta = self.estimate - now

    #  return delta

    #else
    #  return 0
    #end

  end

end

