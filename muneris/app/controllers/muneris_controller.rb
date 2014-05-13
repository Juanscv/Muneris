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

    notifications

    @bills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ?", @user.id),
      order:           'bills.date',
      order_direction: 'desc'
    )

    bills = @user.bills.sort_by(&:date)

    @ebills, @wbills, @gbills = [], [], []

    bills.each do |b|
      case b.service
      when 1
        @ebills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      when 2
        @wbills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      when 3
        @gbills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      end
    end

    @your_ebills, @your_wbills, @your_gbills = [], [], []

    your_bills = current_user.bills.sort_by(&:date)

    your_bills.each do |b|
      case b.service
      when 1
        @your_ebills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      when 2
        @your_wbills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      when 3
        @your_gbills << [b.date.strftime("%B %Y").to_date.strftime("%s%L").to_i,b.consumption]
      end
    end   

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.yAxis({:title => {:text => "Consumption", :margin => 10} })

      f.series(name: "Water bills (kWh)", :yAxis => 0, :data => @wbills)
      f.series(name: "Gas bills (m3)", :yAxis => 0, :data => @gbills)
      f.series(name: "Energy bills (m3)", :yAxis => 0, :data => @ebills)

      f.series(name: "Your water bills (kWh)", :yAxis => 0, :data => @your_wbills)
      f.series(name: "Your gas bills (m3)", :yAxis => 0, :data => @your_gbills)
      f.series(name: "Your energy bills (m3)", :yAxis => 0, :data => @your_ebills)

      f.legend(:align => 'center', :verticalAlign => 'top', :y => 30, :enabled => false, :layout => 'vertical',)  
      f.exporting(:enabled => false)
      f.rangeSelector(:buttons => [])
    end

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
