class FriendshipsController < ApplicationController
    
  before_filter :authenticate_user!

  require 'will_paginate/array'

  def index

    @users_grid = initialize_grid(User.all(:conditions => ["id != ?", current_user.id]))

  end

  def new
    @users = User.all(:conditions => ["id != ?", current_user.id]).paginate(:page => params[:page], :per_page => 8)

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
      #@frienship.create_activity :update, owner: current_user
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
      #@frienship.create_activity :destroy, owner: current_user
      redirect_to network_path, :notice => "Successfully removed friend!"
    else
      redirect_to network_path, :notice => "Sorry, couldn't remove friend!"
    end
  end
  
end
