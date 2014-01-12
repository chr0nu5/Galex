class Document < ActiveRecord::Base
  PERMITTED_FORMATS = [
    "application/vnd.oasis.opendocument.text",
    "application/pdf",
    "application/x-pdf", 
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/msword"
  ]
  attr_accessor :file, :content, :kind_of_document
  
  validates_presence_of :title, :description, :guid, :format
  before_validation :fill_guid, :set_document_format
  validate :check_document_kind
  
  belongs_to :user
  has_many :reads
  has_many :readers, through: :reads, source: :user
  
  # --- methods for tracking dirty state.
  def file=(value)
    attribute_will_change!('file') if file != value
    @file = value
  end
  
  def file_changed?
    changed.include?('file')
  end
  
  def content=(value)
    attribute_will_change!('content') if content != value
    @content = value
  end
  
  def content_changed?
    changed.include?('content')
  end
  # --- end
  
  
  def dissemination_rate 
    ((readers.size.to_f / User.all.size.to_f) * 100).to_i
  end
  
  def belongs_to_user? user
    id = nil
    if user.is_a? User
      id = user.id
    elsif user.is_a? Integer
      id = user
    end
    raise ArgumentError, "User must be either a (existing) User or an Integer" if id == nil
    document.user_id == id
  end
  
  def title_slug
    title.underscore.parameterize
  end
  
  private
  def fill_guid
    self.guid = SecureRandom.uuid unless self.guid.present?
  end
  
  def set_document_format
    if self.file_changed? && !self.content_changed?
      self.format = File.extname(self.file.original_filename).split('.')[1] if self.file.present? && self.file.is_a?(ActionDispatch::Http::UploadedFile)
    elsif !self.file_changed? && self.content_changed?
      self.format = "pdf"
    elsif self.file_changed? && self.content_changed?
      raise ArgumentError, "Detected changes to self.file and self.content. Galex don't know which of them it will store!"
    end
  end
  
  def check_document_kind
    if new_record? || (self.file_changed? || self.content_changed?)
      self.kind_of_document = self.kind_of_document.to_sym

      if(self.kind_of_document != :file && self.kind_of_document != :markdown)
        raise ArgumentError, "New documents must be marked as :file or :markdown through kind_of_document variable."
      else
        if self.kind_of_document == :file
          unless self.file.present?
            self.errors.add(:file, "You must select a file to be uploaded.")
          else
            self.errors.add(:file, "Only odt, doc, docx and pdf files are supported.")  unless PERMITTED_FORMATS.include?(self.file.content_type)
          end
        else 
          unless self.content.present?
            self.errors.add(:content, "Please enter the document's body.")
          else
            self.errors.add(:content, "Please enter the document's body.") if self.content.empty?
          end
            
        end
      end
    end
  end
end
