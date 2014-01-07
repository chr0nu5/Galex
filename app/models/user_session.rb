class UserSession
  include ActiveModel::Model
  attr_accessor :username, :password
  
  validates_presence_of :username, :password
  
  def initialize(session, args={})
    @username = args[:username]
    @password = args[:password]
  end
end