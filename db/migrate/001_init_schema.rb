class InitSchema < ActiveRecord::Migration

  def self.up

    create_table :users do |t|
      t.string :uuid, :unique => true
      t.string :salt
      t.string :token
      t.timestamps 
    end

    create_table :followers do |t|
      t.belongs_to :user
      t.integer :user_id
      t.integer :follow_id
      t.timestamps
    end

    create_table :hashtags do |t|
      t.string :hashtag, :null => false, :unique => true
      t.timestamps
    end

    create_table :actions do |t|
      t.integer :user_id
      t.integer :delegate_id
      t.string :action, :null => false
      t.boolean :visible, :default => false
      t.integer :estimate
      t.timestamp :finished
      t.integer :priority
      t.integer :parent_id
      t.integer :ordinal
      t.timestamps
    end

    create_table :actionhashtags do |t|
      t.integer :action_id
      t.integer :hashtag_id
      t.timestamps
    end

    create_table :comments do |t|
      t.integer :user_id
      t.integer :action_id
      t.string :comment
      t.timestamps
    end

  end

  def self.down

    drop_table :users
    drop_table :followers
    drop_table :hashtags
    drop_table :actions
    drop_table :actionhashtags
    drop_table :comments

  end

end

