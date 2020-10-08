Rails.application.routes.draw do
  get 'sessions/new'
  root 'pages#home'
  
  get  'signup', to: 'users#new'
  resources :users 
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
