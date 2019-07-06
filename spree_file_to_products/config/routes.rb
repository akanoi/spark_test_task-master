Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :products do
      collection do
        get :upload_products_from_file
      end
    end
  end
end
