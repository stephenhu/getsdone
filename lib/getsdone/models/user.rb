module Getsdone

  class User < ActiveRecord::Base
    include BCrypt
  
    has_many :follows, :dependent => :destroy 
    has_many :actions
    has_many :comments
  
    validates_uniqueness_of :uuid
    validates_uniqueness_of :name

    before_create :hash_password
# order or the hash_gravatar call is important
# must happen before hash_uuid since self.uuid is overwritten
    before_create :hash_gravatar
    before_create :hash_uuid

    def raw_password
      return Password.new(self.password)
    end

    def hash_password
      self.password = Password.create(self.password)
    end

    def raw_uuid
      return Password.new(self.uuid)
    end

    def hash_uuid
      self.uuid = Password.create(self.uuid)
    end

    def hash_gravatar
      self.gravatar = Digest::MD5.hexdigest(self.uuid)
    end

    def icon_url

      hash_gravatar if self.gravatar.nil? or self.gravatar.empty?

      return "https://secure.gravatar.com/avatar/#{self.gravatar}"

    end

    def open_actions
  
      #return Action.joins(:delegates).where(
      #  :user_id => self.id, "delegates.user_id" => 1, :completed => false )
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:open] )
  
    end
  
    def overdue_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:open] ).where(
        ["DATE(estimate) <= DATE(?)", Time.now] )
  
    end
  
    def todays_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:open] ).where(
        ["DATE(estimate) = DATE(?)", Time.now] )
  
    end
  
    def upcoming_actions
  
      t = Time.now
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:open] ).where(
        [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)", t,
        t + Getsdone::UPCOMING.days ] )
  
    end
  
    def weeks_actions
  
      t = Time.now
  
      return Action.joins(:delegate).where( "delegates.user_id" => self.id,
        :state => STATE[:open] ).where(
        [ "DATE(estimate) BETWEEN DATE(?) AND DATE(?)",
        t.beginning_of_week, t.end_of_week ] )
  
    end
  
    def completed_actions
  
      return Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:closed] )
  
    end
  
    def hashtag_actions
  
      actions = Action.joins(:delegate).where(
        "delegates.user_id" => self.id, :state => STATE[:open] )
  
      actions.reject! {|a| a.hashtags.length == 0}
  
      return actions
  
    end
  
    def assigned_actions
  
      actions = Action.joins(:delegate).where( :user_id => self.id,
        :state => STATE[:open] ).where( ["delegates.user_id != ?", self.id] )

      reassigned = Action.joins(:delegate).where( :user_id => self.id,
        :state => STATE[:reassigned] ).where( ["delegates.user_id != ?",
        self.id] )

      reassigned.each do |r|

        a = Action.where( :origin_id => r.id, :state => STATE[:open] )
        actions = actions + a unless a.nil?

      end

      # get reassigned open actions
      return actions
  
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
      return { :name => self.name,
        :icon => "https://secure.gravatar.com/avatar/#{self.gravatar}" }
    end
 
    def add_action( action, owner, hashtags, originid=nil, seriesid=nil )
      o = User.find_by_name(owner) unless owner.nil?
      return false if o.nil? and not owner.nil?

      if originid.nil?
        a = self.actions.create( :action => action )
      else

        a = self.actions.create( :action => action, :origin_id => originid,
          :series_id => seriesid )

      end
  
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
  
      if owner.nil?
        id = self.id
      else
        id = o.id
      end
  
      a.create_delegate( :user_id => id )
      a.save
  
      return true
  
    end
  
    def add_actions(params)
 
      owners      = params[:owners]
      hashtags    = params[:hashtags]
      action      = params[:action]
      reassignid  = params[:reassignid]

      id        = get_origin(reassignid)
      seriesid  = get_series(id)
 
      Action.transaction do
  
        if owners.nil?
          res = add_action( action, nil, hashtags )
          return false if res == false
        else
  
          owners.each do |o|
            res = add_action( action, o, hashtags, id, seriesid )
            return false if res == false
          end

          add_series( id, seriesid ) unless id.nil?
  
        end
  
        reassign_action_state(reassignid)

      end

      return true
  
    end

    def add_series( id, series )

      a = Action.find_by_id(id)

      unless a.nil?

        a.series_id = series
        a.save

      end

    end

    def get_series(id)

      if id.nil?
        return nil
      else

        a = Action.find_by_id(id)

        unless a.nil?
          return Digest::MD5.hexdigest(
            id.to_s + a.action)[0,12].downcase
        end

      end

      return nil

    end

    def get_origin(id)

      if id.nil?
        return nil
      else

        a = Action.find_by_id(id)

        if a.nil?
          return nil
        else

          if a.origin_id.nil?
            originid = id
          else
            originid = a.origin_id
          end

        end

      end
        
      return originid
     
    end

    def reassign_action_state(id)

      a = Action.find_by_id(id)
      unless a.nil?

        a.state     = STATE[:reassigned]
        a.finished  = Time.now
        a.save

      end
 
    end

  end

end

