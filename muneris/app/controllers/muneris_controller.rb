class MunerisController < ApplicationController
  
  before_filter :authenticate_user!

  def dashboard
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end

    if current_user.has_address?
      users_nearby = current_user.nearbys(10)
      @users = [current_user]
      @users += users_nearby unless users_nearby.blank?

      @markers = Gmaps4rails.build_markers(@users) do |user, marker|
        if user.has_address?
          marker.lat user.latitude
          marker.lng user.longitude

          # TODO mudar o width e o height para a largura e altura correspondentes
          # a imagem que o icone final possui.
          marker.picture url: user.consumption_picture, width: 32, height: 37
        end
      end
    else
      @markers = [ { lat: 10.96421, lng: -74.797043 } ]
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

  def map
    if current_user.has_address?
      users_nearby = current_user.nearbys(10)
      users = [current_user]
      users += users_nearby unless users_nearby.blank?

      @markers = Gmaps4rails.build_markers(users) do |user, marker|
        if user.has_address?
          marker.lat user.latitude
          marker.lng user.longitude

          # TODO mudar o width e o height para a largura e altura correspondentes
          # a imagem que o icone final possui.
          marker.picture url: user.consumption_picture, width: 32, height: 37
        end
      end
    else
      @markers = [ { lat: 10.96421, lng: -74.797043 } ]
    end
  end

end