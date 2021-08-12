Rails.application.routes.draw do
  resources :animals, only: [:index, :show, :create, :update, :destroy]
  # resources :animals
end
