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

    #return Action.joins(:delegates).where(
    #  :user_id => self.id, "delegates.user_id" => 1, :completed => false )
    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false )

  end

  def overdue_actions

    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false ).where( ["DATE(estimate) <= DATE(?)", Time.now] )

  end

  def todays_actions

    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false ).where( ["DATE(estimate) = DATE(?)", Time.now] )

  end

  def upcoming_actions

    t = Time.now

    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false ).where(
      [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)", t,
      t + Getsdone::UPCOMING.days ] )

  end

  def weeks_actions

    t = Time.now

    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false ).where(
      [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)",
      t.beginning_of_week, t.end_of_week ] )

  end

  def completed_actions

    return self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => true )

  end

  def hashtag_actions

    actions = self.actions.joins(:delegates).where(
      :user_id => self.id, "delegates.user_id" => self.id,
      :completed => false )

    actions.reject! {|a| a.hashtags.length == 0}

    return actions

  end

  def assigned_actions

    return self.actions.joins(:delegates).where(
      :user_id => self.id, :completed => false).where(
      ["delegates.user_id != ?", self.id] )

  end

  def info

    completed = completed_actions.length

    followers = self.followers.length
    f = following.length

    return { :completed => completed, :followers => followers,
      :following => f }

  end

  def action_info

    t = Time.now

    today     = 0
    upcoming  = 0
    week      = 0
    overdue   = 0

    today_begin = t
    today_end   = t.end_of_day

    upcoming_end  = t.end_of_day + Getsdone::UPCOMING.days

    week_begin  = t.beginning_of_week
    week_end    = t.end_of_week

    actions = open_actions

    actions.each do |a|

      if a.estimate >= today_begin and a.estimate <= today_end
        today = today + 1
      end

      if a.estimate >= today_begin and a.estimate <= upcoming_end
        upcoming = upcoming + 1
      end

      if a.estimate < today_begin
        overdue = overdue + 1
      end

      if a.estimate >= week_begin and a.estimate <= week_end
        week = week + 1
      end

    end

    return { :today => today, :week => week, :overdue => overdue,
      :upcoming => upcoming }

  end

  def following
    return Follower.where( :user_id => self.id )
  end

  def is_following(id)

    puts self.followers.inspect

    if self.followers.include?(id)
      return true
    else
      return false
    end

  end

  def add_follower(id)

    unless is_following(id)

      self.followers.create(
        :follow_id => id )

    end

  end

end

