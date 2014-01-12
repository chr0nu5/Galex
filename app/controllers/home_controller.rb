class HomeController < ApplicationController
  before_filter :require_auth
  
  def index
    @documents = Document.all.includes(:user, :reads).order(:updated_at).reverse_order
    @unread_documents = Document.includes(:user).where.not(id: current_user.read_documents.pluck(:id))
  end
end