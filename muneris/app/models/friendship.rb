class Friendship < ActiveRecord::Base
	include PublicActivity::Model
  	tracked

	belongs_to :user
	belongs_to :friend, :class_name => "User"  
end
