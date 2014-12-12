Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :userposts
  resources :leagues do
    resources :games, shallow: true do
      resource :game_events
    end
  end

  root :to => 'users#home', via: 'get'

  #generic static pages
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  #User login/session
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  #games
  post '/games/:id/vote' => 'games#save_vote', via: 'post', as:'save_vote'
  match  '/games/:id/show_events_history', to: 'event_votes#show_events_history', via: 'get', as: 'show_events_history'
  match '/games/:id/end_game', to: 'games#end_game', via: 'get', as: 'end_game'
  match '/games/:id/end_game', to: 'games#end_game_save', via: 'post', as: 'end_game_save'

  match  '/paginate' => 'userposts#paginate', via: 'get'

  #users
  match '/users/paginate' => 'users#paginate', via: 'get'

  #leagues
  get '/leagues/join_league' => 'leagues#join_league', via: 'get', as: 'join_league'
  # get '/leagues/remove_user' => 'leagues#remove_user', via: 'post', as: 'remove_user'
  match '/leagues/:id/add_user', to: 'leagues#add_user_save', via: 'post', as: 'add_user_save'
  get '/leagues/:id/add_user' => 'leagues#add_user', via: 'get', as: 'add_user'
  match '/leagues/:id/expand_league_games' => 'leagues#expand_league_games', via: 'get', as: 'expand_league_games'
  match '/leagues/:id/expand_league_users' => 'leagues#expand_league_users', via: 'get', as: 'expand_league_users'
  match '/leagues/:id/remove_user' => 'leagues#remove_user', via: 'get', as: 'remove_user'
  match '/leagues/:id/remove_user' => 'leagues#remove_user_save', via: 'post', as: 'remove_user_save'



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
