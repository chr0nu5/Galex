class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[^@]+@([^2\.]+\.)+[^@\.]+\z/
  FULL_NAME_REGEX = /([^\s]+)\s(.*)+/
  has_secure_password
  validates_presence_of :full_name, :username, :email
  validates_format_of :email, with: EMAIL_REGEX
  validates_format_of :full_name, with: FULL_NAME_REGEX
  validates_uniqueness_of :username, :email, case_sensitive: false
  before_validation :ensure_downcase
  
  def pretty_name
    data = full_name.split(' ')
    "#{data[0]} #{data[1][0]}."
  end
  
  def first_name
    "#{full_name.split(' ')[0]}"
  end
  
  private
  def ensure_downcase
    @username.downcase!
    @email.downcase!
  end
end
