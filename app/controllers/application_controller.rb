class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :user_signed?, :require_auth, :require_no_auth
  
  def user_signed?
    false
  end
  
  def require_auth
    redirect_to user_sessions_path, notice: "You must login prior proceeding." unless user_signed?
  end
  
  def require_no_auth
    redirect_to user_sessions_path, notice: "You are already logged in" if user_signed?
  end
end
