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
end
