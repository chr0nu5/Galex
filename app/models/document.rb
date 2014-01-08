class Document < ActiveRecord::Base
  validates_presence_of :title, :description, :guid
  before_validation :fill_guid
  
  belongs_to :user
  has_many :reads
  has_many :readers, through: :reads, source: :user
  
  def dissemination_rate 
    (readers.size / User.all.size) * 100
  end
  
  private
  def fill_guid
    self.guid = SecureRandom.uuid unless self.guid.present?
  end
end
