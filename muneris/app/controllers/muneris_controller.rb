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

    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.friends, owner_type: "User")

    @users = User.all(:conditions => ["id != ?", current_user.id])

    notifications

  end

  def profile
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @is_current_user = current_user == @user

    @bills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ?", @user.id),
      order:           'bills.date',
      order_direction: 'desc'

    )

    @bills = Bill.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ?", @user.id)
    
    notifications

  end

  def map
    if current_user.has_address?
      users_nearby = current_user.nearbys(10)
      users = [current_user]
      users += users_nearby unless users_nearby.blank?

      @markers = Gmaps4rails.build_markers(users) do |user, marker|
        if user.has_address?
          marker.infowindow render_to_string(:partial => "/layouts/partials/infowindow", :locals => { :user => user} )
          marker.title user.familyname

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

  private

  def notifications
    @notifications = PublicActivity::Activity.order("created_at desc").where("activities.owner_id = ? AND activities.owner_type = 'User' AND (activities.key = 'bill.alert' OR activities.key = 'friendship.invite')", current_user.id)
  end

end
