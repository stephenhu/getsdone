class Follow < ActiveRecord::Base

  has_and_belongs_to_many :users

  def get_profile(id)

    u = User.find_by_id(id)

    return { :name => u.name, :icon => u.icon }

  end

end

