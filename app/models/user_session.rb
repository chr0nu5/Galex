class UserSession
  include ActiveModel::Model
  attr_accessor :username, :password
  
  validates_presence_of :username, :password
  
  def initialize(session, args={})
    @session = session
    @username = args[:username]
    @password = args[:password]
  end
  
  def auth!
    user = User.find_by(username: @username.downcase)
    return false unless user.present?
    if(user.authenticate(@password))
      store(user)
    else
      false
    end
  end
  
  private
  def store(user)
    session[:user_id] = user.id 
  end
end