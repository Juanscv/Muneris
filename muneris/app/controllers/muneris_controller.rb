class MunerisController < ApplicationController
  def dashboard
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @friendships = Friendship.all
  end

  def profile
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @is_current_user = current_user == @user
  end

  def network
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @friendships = Friendship.all
  end

  def map
  end

  def people
  	@users = User.all.paginate(:page => params[:page], :per_page => 8).search(params[:search])
  end
end
