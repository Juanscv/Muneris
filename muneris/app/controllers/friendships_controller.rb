class FriendshipsController < ApplicationController
    
  before_filter :authenticate_user!

  def index
    if !@user.admin.nil? then
      @user_list = User.all.where(:admin == nil)
    else
      @user_list = User.unscoped.joins('INNER JOIN friendships ON (friendships.friend_id = users.id OR friendships.friendable_id = users.id)').where('users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL', current_user.id, current_user.id, current_user.id)
    end

    @users_grid = initialize_grid(
      @user_list,
      order: 'users.id',
      per_page: 8,
      name: 'g'
     )

    @selected = []

    if params[:g] && params[:g][:selected]
      @selected = params[:g][:selected]
    end

  end

  def new
    @users_grid = initialize_grid(
      User,
      conditions: ["id != ? AND admin = NULL", current_user.id],
      order: 'users.id',
      per_page: 8
    )
  end

  def create
    invitee = User.find_by_id(params[:user_id])
    if current_user.invite invitee
      redirect_to new_network_path, :notice => "Successfully invited friend!"
    else
      redirect_to new_network_path, :notice => "Sorry! You can't invite that user!"
    end
  end

  def update
    inviter = User.find_by_id(params[:id])
    if current_user.approve inviter
      redirect_to new_network_path, :notice => "Successfully confirmed friend!"
    else
      redirect_to new_network_path, :notice => "Sorry! Could not confirm friend!"
    end
  end

  def requests
    @pending_requests = current_user.pending_invited_by
  end

  def invites
    @pending_invites = current_user.pending_invited
  end

  def destroy
    user = User.find_by_id(params[:id])
    if current_user.remove_friendship user
      redirect_to new_network_path, :notice => "Successfully removed friend!"
    else
      redirect_to new_etwork_path, :notice => "Sorry, couldn't remove friend!"
    end
  end
  
end
