class InitSchema < ActiveRecord::Migration

  def self.up

    create_table :users do |t|
      t.string :uuid, :unique => true, :null => false
      t.string :name, :unique => true, :null => false, :limit => 15
      t.string :salt
      t.string :token
      t.string :guid
      t.string :icon, :default => "glyphicons_003_user.png"
      t.timestamps
    end

    create_table :follows do |t|
      t.belongs_to :user
      t.integer :user_id
      t.integer :follow_id
      t.timestamps
    end

    create_table :actions do |t|
      t.belongs_to :user
      t.integer :origin_id
      t.integer :user_id
      t.string :action, :null => false, :limit => 140
      t.boolean :visible, :default => false
      t.integer :duration, :default => 1
      t.timestamp :estimate
      t.timestamp :finished
      t.integer :state, :default => 0
      t.boolean :completed, :default => false
      t.integer :priority, :default => 1
      t.timestamps
    end

    create_table :delegates do |t|
      t.belongs_to :action
      t.integer :action_id
      t.integer :user_id
      t.timestamps
    end

    create_table :tags do |t|
      t.string :tag, :null => false, :unique => true, :limit => 24
      t.timestamps
    end

    create_table :hashtags do |t|
      t.integer :action_id
      t.integer :tag_id
      t.timestamps
    end

    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :action
      t.integer :user_id
      t.integer :action_id
      t.string :comment
      t.timestamps
    end

  end

  def self.down

    drop_table :users
    drop_table :followers
    drop_table :actions
    drop_table :delegates
    drop_table :tags
    drop_table :hashtags
    drop_table :comments

  end

end

