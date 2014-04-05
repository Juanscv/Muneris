class MunerisController < ApplicationController
  def dashboard
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end

    @users = [current_user] + current_user.nearbys(10)

    @markers = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude

      # TODO mudar o width e o height para a largura e altura correspondentes
      # a imagem que o icone final possui.
      marker.picture url: user.consumption_picture, width: 32, height: 37
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

  end

  def map
    @users = [current_user] + current_user.nearbys(10)

    @markers = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude

      # TODO mudar o width e o height para a largura e altura correspondentes
      # a imagem que o icone final possui.
      marker.picture url: user.consumption_picture, width: 32, height: 37
    end
  end

  def people
  	@users = User.all.paginate(:page => params[:page], :per_page => 8).search(params[:search])
  end
end
