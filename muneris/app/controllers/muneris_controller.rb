class MunerisController < ApplicationController
  
  before_filter :authenticate_user!

  def dashboard
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end

    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.friends, owner_type: "User")

    @friends = current_user.friends

    notifications

    @users = User.all(:conditions => ["id != ?", current_user.id])
    @bills = Bill.all

    #------------------------------------ADMIN--------------------------------------

    tariffs = User.where("id != ?", current_user.id).pluck(:tariff).uniq
    @userstariff = []

    locales = User.where("id != ?", current_user.id).pluck(:locale).uniq
    @userscity = []

    services = Bill.pluck(:service).uniq
    @billsservice = []

    @averagestariff = []
    tariffs.each do |tariff|
      users = User.where(tariff: tariff)
      @averagestarifflista = []

      # services
      [1, 2, 3].each do |service|
        bills_total = users.map { |u| u.valor_total(service) }.inject(0, :+)
        if bills_total == 0
          bills_total =1
        end
        consumption = users.map { |u| u.valor(service) }.inject(0, :+)
        @averagestariff << { tariff: tariff, service: service , average: consumption / bills_total }
        @averagestarifflista << { service: service , average: consumption / bills_total }
      end

      @userstariff << { tariff: tariff, value: users.size, averages: @averagestarifflista }

    end

    @bartariff = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'Energy',:data => @averagestariff.select{ |k,v| k[:service] == 1 }.collect { |e| e[:average]  } ) 
      f.series(:name=>'Water',:data=> @averagestariff.select{ |k,v| k[:service] == 2 }.collect { |e| e[:average]  } )
      f.series(:name=>'Gas',:data=> @averagestariff.select{ |k,v| k[:service] == 3 }.collect { |e| e[:average]  } )
      f.xAxis({:categories => @userstariff.collect { |e| e[:tariff]} })  
      f.title({ :text=>"Average by tariff"})
      f.options[:chart][:defaultSeriesType] = "column"
    end

    @averagescity = []
    locales.each do |locale|
      users = User.where(locale: locale) 
      @averagescitylista = []     

      [1, 2, 3].each do |service|
        bills_total = users.map { |u| u.valor_total(service) }.inject(0, :+)
        if bills_total == 0
          bills_total =1
        end
        consumption = users.map { |u| u.valor(service) }.inject(0, :+)
        @averagescity << { locale: locale, service: service , average: consumption / bills_total }
        @averagescitylista << {service: service , average: consumption / bills_total }
      end

      @userscity << { locale: locale.split(",").first, value: User.where(locale: locale).size, averages: @averagescitylista }

    end

    @barcity = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'Energy',:data=> @averagescity.select{ |k,v| k[:service] == 1 }.collect { |e| e[:average]  } )
      f.series(:name=>'Water',:data=> @averagescity.select{ |k,v| k[:service] == 2 }.collect { |e| e[:average]  } )
      f.series(:name=>'Gas',:data=> @averagescity.select{ |k,v| k[:service] == 3 }.collect { |e| e[:average]  } )
      f.xAxis({:categories => @userscity.collect { |e| e[:locale]} })    
      f.title({ :text=>"Average by city"})
      f.options[:chart][:defaultSeriesType] = "column"
    end


    ['Residencial Estrato 1', 'Residencial Estrato 2', 'Residencial Estrato 3','Residencial Estrato 4', 'Residencial Estrato 5', 'Residencial Estrato 6'].each do |tariff|
      users = User.where(tariff: tariff)
      @econsumo = users.map { |u| u.consumo_total_energy}.inject(0, :+)
      @wconsumo = users.map { |u| u.consumo_total_water}.inject(0, :+)
      @gconsumo = users.map { |u| u.consumo_total_gas}.inject(0, :+)
    end

    @echarttariff = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie"})
          series = {:type=> 'pie',:name=> 'Tariff chart',:data=> [['E. 1', 30.0],['E. 4', 22.4],['E. 2', 14.2],['E. 3', 10.2],['E. 5', 17],['E. 6', 6.2]]}
          f.series(series)
          f.options[:title][:text] = "Energy"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
          f.plot_options(:pie=>{:allowPointSelect=>true, :cursor=>"pointer" , :dataLabels=>{:enabled=>true,:color=>"black",:style=>{:font=>"13px Trebuchet MS, Verdana, sans-serif"}}})
    end

    @wcharttariff = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie"})
          # series = {:type=> 'pie',:name=> 'Tariff chart',:data=> [['E. 1', 100 / @econsumo],['E. 4', 100 / @econsumo],['E. 2', 100 / @econsumo],['E. 3', 100 / @econsumo],['E. 5', 100 / @econsumo],['E. 6', 100 / @econsumo]]}
          series = {:type=> 'pie',:name=> 'Tariff chart',:data=> [['E. 1', 30.0],['E. 4', 22.4],['E. 2', 14.2],['E. 3', 10.2],['E. 5', 17],['E. 6', 6.2]]}
          f.series(series)
          f.options[:title][:text] = "Water"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
          f.plot_options(:pie=>{:allowPointSelect=>true, :cursor=>"pointer" , :dataLabels=>{:enabled=>true,:color=>"black",:style=>{:font=>"13px Trebuchet MS, Verdana, sans-serif"}}})
    end

    @gcharttariff = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie"})
          series = {:type=> 'pie',:name=> 'Tariff chart',:data=> [['E. 1', 30.0],['E. 4', 22.4],['E. 2', 14.2],['E. 3', 10.2],['E. 5', 17],['E. 6', 6.2]]}
          f.series(series)
          f.options[:title][:text] = "Gas"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
          f.plot_options(:pie=>{:allowPointSelect=>true, :cursor=>"pointer" , :dataLabels=>{:enabled=>true,:color=>"black",:style=>{:font=>"13px Trebuchet MS, Verdana, sans-serif"}}})
    end

    services.each do |service|
      @billsservice << { service: service, value: Bill.where(service: service).size }
    end   

  end

  def profile
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @is_current_user = current_user == @user

    notifications

    @ebills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ? AND bills.service = 1", @user.id),
      order:           'bills.date',
      order_direction: 'desc',
      per_page: 5
    )
    @wbills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ? AND bills.service = 2", @user.id),
      order:           'bills.date',
      order_direction: 'desc',
      per_page: 5
    )
    @gbills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ? AND bills.service = 3", @user.id),
      order:           'bills.date',
      order_direction: 'desc',
      per_page: 5
    )

    bills = @user.bills.sort_by(&:date)

    @ebills, @wbills, @gbills = [], [], []

    bills.each do |b|
      case b.service
      when 1
        @ebills << [b.date.strftime("%s%L").to_i,b.consumption]
      when 2
        @wbills << [b.date.strftime("%s%L").to_i,b.consumption]
      when 3
        @gbills << [b.date.strftime("%s%L").to_i,b.consumption]
      end
    end

    @your_ebills, @your_wbills, @your_gbills = [], [], []

    if !@is_current_user then
      your_bills = current_user.bills.sort_by(&:date)
      your_bills.each do |b|
        case b.service
        when 1
          @your_ebills << [b.date.strftime("%s%L").to_i,b.consumption]
        when 2
          @your_wbills << [b.date.strftime("%s%L").to_i,b.consumption]
        when 3
          @your_gbills << [b.date.strftime("%s%L").to_i,b.consumption]
        end
      end   
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.yAxis({:title => {:text => "Consumption", :margin => 10} })

      f.series(name: "Water bills (m3)", :yAxis => 0, :data => @wbills)
      f.series(name: "Gas bills (m3)", :yAxis => 0, :data => @gbills)
      f.series(name: "Energy bills (kWh)", :yAxis => 0, :data => @ebills)

      f.series(name: "Your water bills (m3)", :yAxis => 0, :data => @your_wbills)
      f.series(name: "Your gas bills (m3)", :yAxis => 0, :data => @your_gbills)
      f.series(name: "Your energy bills (kWh)", :yAxis => 0, :data => @your_ebills)

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
    
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
  end

  def statistics
    @ebills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id INNER JOIN friendships ON (friendships.friend_id = users.id OR friendships.friendable_id = users.id)").where("users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL AND bills.service = 1", current_user.id, current_user.id, current_user.id)
    )
    @wbills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ? AND bills.service = 2", @user.id)
    )
    @gbills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ? AND bills.service = 3", @user.id)
    )
  end

  private

  def notifications
    @notifications = PublicActivity::Activity.order("created_at desc").where("activities.owner_id = ? AND activities.owner_type = 'User' AND (activities.key = 'bill.alert' OR activities.key = 'friendship.invite')", current_user.id)
  end

end
