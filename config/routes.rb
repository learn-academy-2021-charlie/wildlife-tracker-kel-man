Rails.application.routes.draw do
  resources :animals, only: [:index, :show, :create, :update, :destroy]
  resources :sightings, only: [:index, :show, :create, :update, :destroy]
end
