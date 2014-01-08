class HomeController < ApplicationController
  before_filter :require_auth
  
  def index
    @documents = Document.all.order(:updated_at).reverse_order
    @unread_documents = Document.where.not(id: current_user.read_documents.pluck(:id))
  end
end