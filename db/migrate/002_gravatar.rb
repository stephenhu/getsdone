class Gravatar < ActiveRecord::Migration

  def self.up

    add_column :users, :gravatar, :string

  end

  def self.down

    remove_column :users, :gravatar

  end

end

