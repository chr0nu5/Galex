class SearchResult
  include ActiveModel::Model
  attr_accessor :title, :url, :text, :object
  
  def initialize(params = {})
    @title = params[:title]
    @url = params[:url]
    @text = params[:text]
    @object = params[:object]
  end
  
  def as_json(options)
    super(only: [:title, :url, :text])
  end
end