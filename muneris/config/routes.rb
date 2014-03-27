Muneris::Application.routes.draw do

  resources :bills

  resources :friendships

  get "/user/:id/feed", to: 'user#feed', as: :feed
  get "/user/:id/notifications", to: 'user#notifications', as: :notifications
  get "/user/:id/friends", to: 'user#friends', as: :friends
  get "/dashboard", to: 'muneris#dashboard', as: :dashboard
  get "/profile(/:user_id)", to: 'muneris#profile', as: :profile
  get "/network", to: 'muneris#network', as: :network
  get "/map", to: 'muneris#map', as: :map
  get "/people", to: 'muneris#people', as: :people
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }



  root to: "welcome#index"

  authenticated :user do
    root :to => "muneris#dashboard" , :as => "authenticated_root"
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
  end

end
