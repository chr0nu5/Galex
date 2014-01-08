class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :user_signed?, :require_auth, :require_no_auth, :current_user, :current_user_owns?
  
  def user_signed?
    session[:user_id].present?
  end
  
  def require_auth
    redirect_to user_sessions_path, notice: "You must login prior proceeding." unless user_signed?
  end
  
  def require_no_auth
    redirect_to user_sessions_path, notice: "You are already logged in" if user_signed?
  end
  
  def current_user
    User.find(session[:user_id])
  end
  
  def current_user_owns? object
    session[:user_id] == object.user_id
  end
end
