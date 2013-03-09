class Action < ActiveRecord::Base

  has_many :hashtags
  has_many :tags, :through => :hashtags

  belongs_to :user

  def open_actions

    actions = Actions.where( :finished => nil ).all

    return actions

  end

  def closed_actions

    closed = Actions.where( :finished => :timestamp ).all

  end

end

