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
      with_resultset: :process_records,
      per_page: 8,
      name: 'g'
     )

    @averageslist = []
    [1, 2, 3].each do |service|
      resultado = @user_list.map { |u| u.calculo(service) }
      @averageslist << {service: service , average: resultado }
    end

    @results = []

    if params[:g] && params[:g][:selected]
      @selected = params[:g][:selected]
    end

    # @averageservices = []  

    # [1, 2, 3].each do |service|
    #   bills_total = @user_list.map { |u| u.valor_total(service) }.inject(0, :+)
    #   if bills_total == 0
    #     bills_total =1
    #   end
    #   consumption = @user_list.map { |u| u.valor(service) }.inject(0, :+)
    #   @averageservices << {service: service , average: consumption / bills_total }
    # end

    # @barservice = LazyHighCharts::HighChart.new('column') do |f|
    #   if @current_user.admin == 1 
    #     f.series(:name=>'Energy',:data=> @averageservices.select{ |k,v| k[:service] == 1 }.collect { |e| e[:average]  } )
    #   elsif @current_user.admin == 2        
    #     f.series(:name=>'Water',:data=> @averageservices.select{ |k,v| k[:service] == 2 }.collect { |e| e[:average]  } )
    #   elsif @current_user.admin == 3 
    #     f.series(:name=>'Gas',:data=> @averageservices.select{ |k,v| k[:service] == 3 }.collect { |e| e[:average]  } )
    #   else
    #     f.series(:name=>'Energy',:data=> @averageservices.select{ |k,v| k[:service] == 1 }.collect { |e| e[:average]  } )
    #     f.series(:name=>'Water',:data=> @averageservices.select{ |k,v| k[:service] == 2 }.collect { |e| e[:average]  } )
    #     f.series(:name=>'Gas',:data=> @averageservices.select{ |k,v| k[:service] == 3 }.collect { |e| e[:average]  } )
    #   end  
    #   f.title({ :text=>"Average consume of my friends by service"})
    #   f.options[:chart][:defaultSeriesType] = "column"
    # end

  end

  def new
    @users_grid = initialize_grid(
      User,
      conditions: ["id != ?", current_user.id],
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

  def process_records(records)
    records.each do |rec|
      @results << rec
    end
  end
  
end
