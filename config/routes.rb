Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :groups do
    resources :students
    resources :stores do
      member do
        get "approve"
        get "deny"
      end
      resources :store_owners, only: [:new, :create, :destroy]
      resources :store_managers, only: [:new, :create, :destroy]
    end
    resources :accounts
    resources :jobs, except: [:show]
    resources :charges
    resources :transfers do
      collection do
        get "new_class_transfer"
        post "create_class_transfer"
      end
      member do
        get "undo"
      end
    end
    resources :disputes
    resources :job_assignments, only: [:new, :create, :destroy]

    resources :bills do
      member do
        get "pay_bill"
      end
    end
  end

  resources :users

  get "switch_user" => "root#switch_user"
  root to: "root#index"

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
