Galex::Application.routes.draw do
  root 'home#index'
  resources :user_sessions
  resources :documents
  resources :users
  resource :search, only: :create
  match 'signout', to: 'user_sessions#destroy', via: :delete
  match '/documents/:id/download', to: 'documents#download', via: :get, as: :download_document
  match '/documents/:id/upload', to: 'documents#upload', via: :get, as: :upload_document
  match '/documents/new/markdown', to: 'documents#new_markdown', via: :get, as: :new_markdown_document
  match '/documents/new/markdown', to: 'documents#commit_markdown', via: :post, as: :commit_markdown_document
  match '/documents/:id/upload/file', to: 'documents#upload_file', via: :get, as: :update_document_with_file
  match '/documents/:id/upload/file', to: 'documents#commit_upload_file', via: :post, as: :commit_document_update_with_file
  match '/documents/:id/upload/markdown', to: 'documents#upload_markdown', via: :get, as: :update_document_with_markdown
  match '/documents/:id/upload/markdown', to: 'documents#commit_upload_markdown', via: :post, as: :commit_document_update_with_markdown
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
