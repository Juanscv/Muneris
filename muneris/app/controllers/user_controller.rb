class UserController < ApplicationController

	def feed
		render partial: 'feed'
	end

	def notifications
		render partial: 'notifications'
	end

	def friends
		render partial: 'friends'  	
	end

	def destroy
	  User.find(params[:id]).destroy
	  flash[:success] = "User destroyed with success."
	  redirect_to new_network_path
	end
end
