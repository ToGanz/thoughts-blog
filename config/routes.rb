Rails.application.routes.draw do
  root 'pages#home'
  
  get  'signup', to: 'users#new'
  resources :users 
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :posts
  resources :comments, only: [:create, :destroy]
end
