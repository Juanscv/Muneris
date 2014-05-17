class BillsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  # GET /bills.json
  def index
    @bills_grid = initialize_grid(
      Bill.unscoped.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id").where("users.id = ?", current_user.id),
      order:           'bills.date',
      order_direction: 'desc',
      per_page: 20
    )

    bills = current_user.bills.sort_by(&:date)

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

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Bill history")
      f.yAxis({:title => {:text => "Consumption", :margin => 20} })

      f.series(name: "Water bills (m3)", :yAxis => 0, :data => @wbills)
      f.series(name: "Gas bills (m3)", :yAxis => 0, :data => @gbills)
      f.series(name: "Energy bills (kWh)", :yAxis => 0, :data => @ebills)

      f.legend(:align => 'center', :verticalAlign => 'top', :y => 30)    
      f.exporting(:enabled => false)     
    end

  end

  # GET /bills/1
  # GET /bills/1.json
  def show
  end

  # GET /bills/new
  def new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        current_user.userbills.create!(bill_id: @bill.id)

        @bill.create_activity :create, owner: current_user, parameters: Hash["consumption" => consumption, "value" => value, "time" => time]
      
        alerts
              
        format.html { redirect_to profile_path, notice: 'Bill was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bill }
      else
        format.html { render action: 'new' }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        @bill.create_activity :update, owner: current_user, parameters: Hash["consumption" => consumption, "value" => value, "time" => time]
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    # @bill.create_activity :destroy, owner: current_user
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(:consumption, :value, :service, :date)
    end

    def alerts

      avg_bill_yours = current_user.bills.where(:service => @bill.service).average(:consumption)

      avg_bill_friends = Bill.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id INNER JOIN friendships ON (users.id = friendships.friendable_id OR users.id = friendships.friend_id)").where('bills.service = ? AND users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL', @bill.service, current_user.id, current_user.id, current_user.id).average("consumption").to_f

      avg_bill_tariff = Bill.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id INNER JOIN friendships ON (users.id = friendships.friendable_id OR users.id = friendships.friend_id)").where('bills.service = ? AND users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL AND users.tariff = ?', @bill.service, current_user.id, current_user.id, current_user.id, current_user.tariff).average("consumption").to_f

      avg_bill_neighbors = Bill.joins("INNER JOIN userbills ON userbills.bill_id = bills.id INNER JOIN users ON userbills.user_id = users.id INNER JOIN friendships ON (users.id = friendships.friendable_id OR users.id = friendships.friend_id)").where('bills.service = ? AND users.id not IN (?) AND (friendships.friendable_id= ? OR friendships.friend_id = ?) AND friendships.pending = 0 AND friendships.blocker_id IS NULL AND users.address = ?', @bill.service, current_user.id, current_user.id, current_user.id, current_user.address).average("consumption").to_f

      if    @bill.consumption > 2.05*avg_bill_friends   and !avg_bill_friends.zero?
        create_alert
      elsif @bill.consumption > 1.8*avg_bill_tariff     and !avg_bill_tariff.zero?
        create_alert
      elsif @bill.consumption > 1.65*avg_bill_neighbors and !avg_bill_neighbors.zero?
       create_alert
      elsif @bill.consumption > 1.5*avg_bill_yours      and current_user.bills.where(:service => @bill.service).count > 1
        create_alert
      end

    end

    def create_alert
      PublicActivity::Activity.create!({
            :trackable_id =>@bill.id,
            :trackable_type => "Bill",
            :owner_id => current_user.id,
            :owner_type => "User",
            :key => "bill.alert",
            :parameters => Hash["consumption" => consumption, "value" => value, "time" => time]
            })
    end

    def consumption
      case @bill.service
      when 1
        @bill.consumption.to_s + " kWh"
      else 
        @bill.consumption.to_s + " m3"
      end
    end

    def value
      number_to_currency(@bill.value.to_i, :precision => 0)
    end

    def time
      @bill.date.strftime("%b %Y")
    end
end
