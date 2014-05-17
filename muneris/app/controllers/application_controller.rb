class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include PublicActivity::StoreController

  # helper_method :current_user
  
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :notifications

  before_filter :defining_user

  def notifications
    if !current_user.nil? then
      @notifications = PublicActivity::Activity.order("created_at desc").where("activities.owner_id = ? AND activities.owner_type = 'User' AND (activities.key = 'bill.alert' OR activities.key = 'friendship.invite')", current_user.id)
    end
  end

  def defining_user
    if params[:user_id].nil? then
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end  
  end


  protected

  def configure_permitted_parameters

    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :familyname, :address, :tariff, :locale, :avatar) }

  end

  def after_sign_in_path_for(resource)
	dashboard_path
  end
  def after_sign_up_path_for(resource)
	dashboard_path
  end

  def after_sign_out_path_for(resource)
	root_path
  end  
  
end
