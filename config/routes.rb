# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: 'authentication' }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  mount OMG::API => '/'

  mount ActionCable.server => '/cable'

  # # Allow activestorage blob paths
  # scope ActiveStorage.routes_prefix do
  #   get "/blobs/redirect/:signed_id/*filename" => "secure_blobs#show"
  # end

  root "main#index"
  # get '*path' => redirect('/'), constraints: lambda { |req|
  #   req.path.exclude? 'rails/active_storage'
  # }
end
