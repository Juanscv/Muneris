class Bill < ActiveRecord::Base
	include PublicActivity::Model
  	tracked
  	
	has_many :userbills
 	has_many :users, :through => :userbills

end
