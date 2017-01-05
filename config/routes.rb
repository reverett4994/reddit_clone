Rails.application.routes.draw do
  resources :admins
  resources :posts
  resources :comments
  get 'user/show'

  devise_for :users
  resources :subreddits
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
    root 'subreddits#top'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
      get 'user/:username' => 'user#show'
      get 'subreddit/subscribe' =>'subreddits#subscribe'
      get 'subreddit/unsubscribe' =>'subreddits#unsubscribe'
      get 'subreddit/admin' =>'subreddits#admin'
      get 'subreddit/removeadmin' =>'subreddits#removeadmin'
      get '/top' =>'subreddits#top'
      get '/new' =>'subreddits#newist'
      get '/all' => 'subreddits#all'
      get '/search' => 'subreddits#search'

      post 'post/vote' =>'posts#vote'
      post 'comment/vote' =>'comments#vote'

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
