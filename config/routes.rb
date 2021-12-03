Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'doctrines/index'
      post 'doctrines/create'
      get 'doctrines/:id', to: 'doctrines#show'
      delete 'doctrines/destroy/:id', to: 'doctrines#destroy'
    end
  end

  root 'homepage#index'
  get '/*path' => 'homepage#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
