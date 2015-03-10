Rails.application.routes.draw do
  resources :users do
    get 'search', on: :member
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :userposts do
    resources :comments, only: [:new, :create, :destroy]
  end
  resources :leagues do
    resources :games, shallow: true do
      get 'game_settings', on: :member
      resource :game_events
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy] do
    member do
      post 'accept'
      delete 'friend_request_reject'
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
  match '/games/:id/expand_vote_detail', to: 'event_votes#expand_vote_detail', via: 'get', as: 'expand_vote_detail'
  match '/games/:id/ajax_userpost_form', to: 'games#ajax_userpost_form', via: 'get', as: 'ajax_userpost_form'
  match '/games/:id/ajax_vote_form', to: 'games#ajax_vote_form', via: 'get', as: 'ajax_vote_form'

  match  '/paginate' => 'userposts#paginate', via: 'get'

  #users
  match '/users/paginate' => 'users#paginate', via: 'get'
  match '/users/:id/crop' => 'users#crop', via: 'get'

  #leagues
  match '/leagues/join_league' => 'leagues#join_league', via: 'get', as: 'join_league'
  match '/leagues/:id/add_user', to: 'leagues#add_user_save', via: 'post', as: 'add_user_save'
  match '/leagues/:id/add_user' => 'leagues#add_user', via: 'get', as: 'add_user'
  match '/leagues/:id/expand_league_games' => 'leagues#expand_league_games', via: 'get', as: 'expand_league_games'
  match '/leagues/:id/expand_league_users' => 'leagues#expand_league_users', via: 'get', as: 'expand_league_users'
  match '/leagues/:id/remove_user' => 'leagues#remove_user', via: 'get', as: 'remove_user'
  match '/leagues/:id/remove_user' => 'leagues#remove_user_save', via: 'post', as: 'remove_user_save'
  match '/leagues/:id/end_league', to: 'leagues#end_league', via: 'get', as: 'end_league'
  match '/leagues/:id/end_league', to: 'leagues#end_league_save', via: 'post', as: 'end_league_save'

  #userposts
  match '/userposts/:id/ajax_view_photo', to: 'userposts#ajax_view_photo', via: 'get', as: 'ajax_view_photo'



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
