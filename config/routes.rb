# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: 'authentication',
                                               sessions: 'players/sessions',
                                               registrations: 'players/registrations'
  }, defaults: { format: :json }

  devise_scope :player do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :player, only: [:index]

  resources :doctrines, only: [:index, :show]

  resources :companies, only: [:index, :show]

  root "main#index"
end
