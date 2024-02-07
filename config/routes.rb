Rails.application.routes.draw do
  resources :users
  root "users#index"

  get 'home', to: "home#index"
  get 'register', to: 'users#register'
  post 'auth', to: 'session#auth'
  get 'logout', to: 'session#logout'
end
