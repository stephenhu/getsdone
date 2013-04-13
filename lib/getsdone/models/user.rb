module Getsdone

  class User < ActiveRecord::Base
  
    has_many :follows, :dependent => :destroy 
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
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => false )
  
    end
  
    def overdue_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => false ).where(
        ["DATE(estimate) <= DATE(?)", Time.now] )
  
    end
  
    def todays_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => false ).where(
        ["DATE(estimate) = DATE(?)", Time.now] )
  
    end
  
    def upcoming_actions
  
      t = Time.now
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => false ).where(
        [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)", t,
        t + Getsdone::UPCOMING.days ] )
  
    end
  
    def weeks_actions
  
      t = Time.now
  
      return Action.joins(:delegate).where( "delegates.user_id" => self.id,
        :completed => false ).where(
        [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)",
        t.beginning_of_week, t.end_of_week ] )
  
    end
  
    def completed_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => true )
  
    end
  
    def hashtag_actions
  
      actions = Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :completed => false )
  
      actions.reject! {|a| a.hashtags.length == 0}
  
      return actions
  
    end
  
    def assigned_actions
  
      return Action.joins(:delegate).where( :user_id => self.id,
        :completed => false ).where( ["delegates.user_id != ?", self.id] )
  
    end
  
    def info
  
      completed = completed_actions.length
  
      return { :completed => completed, :follows => self.follows.length,
        :followers => followers.length }
  
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
  
    def followers
      return Follow.where( :follow_id => self.id )
    end
  
    def is_following(id)
  
      f = self.follows.where( :follow_id => id )
  
      if f.length == 0
        return false
      else
        return true
      end
  
    end
  
    def add_follower(id)
  
      unless is_following(id)
  
        self.follows.create( :follow_id => id )
        self.save
      end
  
    end
  
    def remove_follower(id)
  
      if is_following(id)
  
        f = self.follows.find_by_follow_id(id)
  
        self.follows.delete(f) unless f.nil?
  
      end
  
    end
  
    def profile
      return { :name => self.name, :icon => self.icon }
    end
 
    def add_action( action, owner, hashtags, originid=nil, seriesid=nil )
  
      if originid.nil? or originid.empty?
        a = self.actions.create( :action => action )
      else

        if seriesid.nil? or seriesid.empty?
          a = self.actions.create( :action => action, :origin_id => originid )
        else
          a = self.actions.create( :action => action, :origin_id => originid,
            :series_id => seriesid )
        end

      end

      a.save
  
      unless hashtags.nil?
  
        hashtags.each do |h|
  
          t = Tag.find_by_tag(h)
  
          if t.nil?
            a.tags.create( :tag => h )
          else
            a.hashtags.create( :tag_id => t.id )
          end
  
          a.save
  
        end
  
      end
  
      o = User.find_by_name(owner) unless owner.nil?
  
      if o.nil?
        id = self.id
      else
        id = o.id
      end
  
      a.create_delegate( :user_id => id )
      a.save
  
      return true
  
    end
  
    def add_actions(params)
 
      owners    = params[:owners]
      hashtags  = params[:hashtags]
      action    = params[:action]
      originid  = params[:originid]

      if originid.nil? or originid.empty?
        seriesid = nil
      else

        seriesid = Digest::MD5.hexdigest(
          originid.to_s + action)[0,12].downcase

      end

      Action.transaction do
  
        if owners.nil?
          add_action( action, nil, hashtags )
        else
  
          owners.each do |o|
            add_action( action, o, hashtags, originid, seriesid )
          end
  
        end
  
        complete_action(originid)

      end
  
    end
  
    def complete_action(id)

      a = self.actions.find_by_id(id)

      unless a.nil?

        a.completed = true
        a.finished  = Time.now
        a.save

      end
 
    end

  end

end

