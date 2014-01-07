class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[^@]+@([^2\.]+\.)+[^@\.]+\z/
  FULL_NAME_REGEX = /([^\s]+)\s(.*)+/
  has_secure_password
  validates_presence_of :full_name, :username, :email
  validates_format_of :email, with: EMAIL_REGEX
  validates_format_of :full_name, with: FULL_NAME_REGEX
  validates_uniqueness_of :username, :email, case_sensitive: false
  before_validation :ensure_downcase
  
  
  
  private
  def ensure_downcase
    @username.downcase!
    @email.downcase!
  end
end
