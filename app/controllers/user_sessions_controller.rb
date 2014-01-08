class UserSessionsController < ApplicationController
  def index
    new
  end
  
  def new
    @user_session = UserSession.new(session)
    render :new
  end
  
  def create
    @user_session = UserSession.new(session, params[:user_session])
    render :new unless @user_session.valid?
    if @user_session.auth!
      redirect_to root_path, success: "Welcome back, #{@user_session.user.first_name}"
    else
      @user_session.errors.add(:base, "Invalid credentials.")
      redirect_to root_path if @user_session.auth!
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end