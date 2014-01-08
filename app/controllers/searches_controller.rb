class SearchesController < ApplicationController
  before_filter :require_auth
  
  def create
    redirect_to root_path unless params[:search].present?
    @term = params[:search]
    @results = Document.where(["title LIKE :term OR description LIKE :term ", {
      term: "%#{params[:search]}%"
    }]).map do |doc|
      SearchResult.new(title: doc.title, 
      url: document_path(doc), 
      text: doc.description,
      object: doc)
    end
  end
end