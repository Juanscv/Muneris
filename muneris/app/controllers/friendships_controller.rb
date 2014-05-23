class FriendshipsController < ApplicationController
    
  before_filter :authenticate_user!

  def index
    if !@user.admin.nil? then
      @user_list = User.select('users.id, users.familyname, users.address, users.locale, users.tariff, users.avatar_file_name').where('admin IS NULL')
    else
      @user_list = current_user.friends
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
    @user_list = User.select('users.id, users.familyname, users.address, users.locale, users.tariff, users.avatar_file_name')
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
