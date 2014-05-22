class FriendshipsController < ApplicationController
    
  before_filter :authenticate_user!

  def index
    if !@user.admin.nil? then
      @user_list = Rails.cache.fetch('#{@users_list}') do
        User.select('users.id, users.familyname, users.address, users.locale, users.tariff, users.avatar_file_name').where('admin IS NULL')
      end
    else
      @user_list = Rails.cache.fetch('#{@users_list}') do
        User.unscoped.select('users.id, users.familyname, users.address, users.locale, users.tariff, users.avatar_file_name').joins('INNER JOIN friendships ON (friendships.friend_id = users.id OR friendships.friendable_id = users.id)').where('users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL AND users.admin IS NULL', current_user.id, current_user.id, current_user.id)
      end
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
    @user_list = Rails.cache.fetch('#{@users_list}') do
      User.select('users.id, users.familyname, users.address, users.locale, users.tariff, users.avatar_file_name')
    end
    @users_grid = initialize_grid(
      @user_list,
      conditions: ["id != ? AND admin IS NULL", current_user.id],
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
