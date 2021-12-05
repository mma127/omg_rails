Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get "/auth/steam" => "authentication#new"
  get "/signin" => "sessions#new", :as => :signin
  get "/auth/steam/callback" => "sessions#callback"
  get "/signout" => "sessions#destroy", :as => :signout
  get '/auth/failure' => 'sessions#failure'

  resources :doctrines, only: [:index, :show]

  resources :companies, only: [:index, :show]

end
