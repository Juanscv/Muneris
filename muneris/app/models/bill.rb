class Bill < ActiveRecord::Base
	include PublicActivity::Common
  	# tracked owner: ->(controller, model) { controller && controller.current_user }
  	
	has_many :userbills , :dependent => :destroy
 	has_many :users, :through => :userbills

 	def to_s
 		"(#{id})"
 	end

end
