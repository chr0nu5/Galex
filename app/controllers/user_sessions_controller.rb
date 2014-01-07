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
  end
  
  def destroy
  end
end