class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # after_filter :store_action
  
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:phone, :username, :email, :client_id, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :phone, :username, :email, :client_id, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:phone, :username, :email, :client_id, :password, :password_confirmation, :current_password) }
  end

  def after_sign_in_path_for(resource)
  	session[:current_client_id] = params[:member][:client_id]

  	if current_client.nil?
  		sign_out resource
  	end

    sign_in_url = new_member_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def current_client
  	Client.find_by_id(session[:current_client_id])
  end
end
