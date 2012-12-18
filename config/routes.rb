Iqm::Application.routes.draw do

  resources :segments

  resources :event_types do
    resources :segments, only: :index
  end

  # match 'szkolenie/:training_id/zapisz-sie'   => 'orders#register', as: 'register'
  # match 'szkolenie/:training_id/potwierdz'    => 'orders#preview',  as: 'preview'
  # match 'szkolenie/:training_id/zamowienie-potwierdzone' => 'orders#confirm',  as: 'confirm'

  resources :trainings do
    get 'offer', on: :collection
    post 'create_from_exemplary', on: :member
    resources :orders do
      collection do
        get   'register'
        post  'preview'
        post  'confirm'
      end
    end
  end

  resources :companies

  resources :clients

  resources :orders

  resources :users

  resources :trainings

  resources :offers, shallow: true do
    resources :quotes do
      resources :income_variants,:cost_items
    end
  end

  root to: 'offers#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
