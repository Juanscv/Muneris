Muneris::Application.routes.draw do


  authenticated :user do
    root :to => "muneris#dashboard" , :as => "authenticated_root"
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
  end

  root :to => "welcome#index"

  resources :bills

  resources :network, :controller => 'friendships', :except => [:show, :edit] do
    get "requests", :on => :collection
    get "invites", :on => :collection
  end
  
  get "/user/:id/feed", to: 'user#feed', as: :feed
  get "/user/:id/notifications", to: 'user#notifications', as: :notifications
  get "/user/:id/network", to: 'user#network', as: :usernetwork
  get "/dashboard", to: 'muneris#dashboard', as: :dashboard
  get "/profile(/:user_id)", to: 'muneris#profile', as: :profile
  get "/map", to: 'muneris#map', as: :map
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  

end
