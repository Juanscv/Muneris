Muneris::Application.routes.draw do

  get "/user/:id/feed", to: 'user#feed', as: :feed
  get "/user/:id/notifications", to: 'user#notifications', as: :notifications
  get "/user/:id/friends", to: 'user#friends', as: :friends
  get "/dashboard", to: 'muneris#dashboard', as: :dashboard
  get "/profile", to: 'muneris#profile', as: :profile
  get "/network", to: 'muneris#network', as: :network
  get "/map", to: 'muneris#map', as: :map
  devise_for :users

  root to: "welcome#index"

end
