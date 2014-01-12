require 'rdiscount'
require 'pdfkit'

class DocumentsController < ApplicationController
  before_filter :require_auth 
 
  
  def index
    redirect_to root_path
  end
  
  def show
    @document = Document.find(params[:id])
    @size = File.size(document_path @document)
  end
  
  def new 
    @document = current_user.documents.build(kind_of_document: :file)
  end
  
  def new_markdown
    @document = current_user.documents.build(kind_of_document: :markdown)
    @post_to = commit_markdown_document_path
    render :new
  end
  
  def commit_markdown
    @document = current_user.documents.build(document_markdown_params)
    unless @document.save!
      render :new
    else
      @document.readers.append current_user
      html = RDiscount.new(@document.content).to_html
      kit = PDFKit.new(html)
      kit.stylesheets << stylesheet_path("uikit.almost-flat")
      file = kit.to_file(document_path(@document))
      redirect_to @document
    end
  end
  
  def create
    params = document_params
    @document = current_user.documents.build(document_params)
    
    render :new unless @document.valid?
    
    if @document.save!
      handle_io_operations @document
      @document.readers.append(current_user)
      redirect_to @document
    else
      @document.errors.add(:base, "Galex failed to store your document. Please try again.")
      render :new
    end
    
  end
  
  
  def edit
    @document = current_user.documents.find(params[:id])
  end
  
  def update
    @document = current_user.documents.find(params[:id])
    render :edit unless @document.update_attributes(document_params)
    redirect_to @document
  end
  
  def destroy
    @document = current_user.documents.find(params[:id])
    if @document.destroy!
      File.delete document_path(@document)
      redirect_to root_path, flash: { success: "Your document, \"#{@document.title}\" was destroyed." }
    else
      render :show, error: "Could not destroy document. Try again."
    end
  end
  
  def upload
    @document = current_user.documents.find(params[:id])
  end
  
  def upload_markdown
    @document = current_user.documents.find(params[:id])
    @document.kind_of_document = :markdown
  end
  
  def commit_upload_markdown
    @document = current_user.documents.find(params[:id])
    @document.kind_of_document = :markdown
    @document.content = params[:document][:content]
    unless @document.valid?
      render :upload_markdown
    else
      @document.touch
      @document.reads.where.not(user_id: @document.user_id).destroy_all
      html = RDiscount.new(@document.content).to_html
      kit = PDFKit.new(html)
      kit.stylesheets << stylesheet_path("uikit.almost-flat")
      file = kit.to_file(document_path(@document))
      redirect_to @document
    end
  end
  
  def upload_file
    @document = current_user.documents.find(params[:id])
    @document.kind_of_document = :file
  end
  
  def commit_upload_file
    @document = current_user.documents.find(params[:id])
    @document.kind_of_document = :file
    @document.file = 000 # hackhack
    @document.file = params[:document][:file]
    unless @document.valid? 
      render :upload_file 
    else
      handle_io_operations @document
      @document.reads.where.not(user_id: @document.user_id).destroy_all
      @document.touch
      redirect_to @document, flash: { success: "Your document was overwritten."}
    end
  end
  
  def download
    @document = Document.find(params[:id])
    @document.readers.append(current_user)
    send_file document_path(@document),
      filename: "#{@document.title_slug}.#{@document.format}",
      type: Rack::Mime::MIME_TYPES[".#{@document.format}"]
  end
  
  private
  def fields
    params.require(:document)
  end
  def base_document_params
    [:title, :description, :kind_of_document]
  end
  
  def document_params
    fields.permit(base_document_params + [:file])
  end
  
  def document_upload_params
    fields.permit(:file)
  end
  
  def document_markdown_params
    fields.permit(base_document_params + [:content])
  end
  
  def document_path document
    File.join(Rails.root, "private", "documents", "#{document.guid}.#{document.format}")
  end
  
  def handle_io_operations document
    FileUtils.mv(document.file.tempfile.to_path.to_s, document_path(document))
  end
  
  def stylesheet_path name
    File.join(Rails.root, "vendor", "assets", "stylesheets", "#{name}.css")
  end
  
  
end