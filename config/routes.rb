Rails.application.routes.draw do
  root :to => 'welcome#index'

  get "/rooms", to: "rooms#show"

  get "/card", to: "cards#show"

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: [ :create, :show ]

  mount ActionCable.server => "/cable"
end
