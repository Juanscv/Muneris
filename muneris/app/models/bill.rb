class Bill < ActiveRecord::Base
	include PublicActivity::Common
  	# tracked owner: ->(controller, model) { controller && controller.current_user }
  	
	has_many :userbills
 	has_many :users, :through => :userbills

end
