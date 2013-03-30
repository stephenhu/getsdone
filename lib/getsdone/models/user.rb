require "digest/md5"
require "securerandom"

class User < ActiveRecord::Base

  has_many :followers
  has_many :actions
  has_many :comments

  validates_uniqueness_of :uuid
  validates_uniqueness_of :name

  before_create :hash_uuid

  def hash_uuid
    self.uuid = Digest::MD5.hexdigest(self.uuid + self.salt)
  end

  def open_actions

    return Action.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => 1, :completed => false )

  end

  def following
    return Follower.where( :user_id => self.id )
  end

end
