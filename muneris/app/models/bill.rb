class Bill < ActiveRecord::Base
	has_many :userbills
 	has_many :users, :through => :userbills
end
