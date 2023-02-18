Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # resources :users 

  #routes for users prefix 
  # get 'users', to: 'users#index', as: 'users'  
  # post 'users', to: 'users#create'
  #routes for user prefix 
  # get 'users/:id', to: 'users#show', as: 'user'
  # patch 'users/:id', to: 'users#update'
  # put 'users/:id', to: 'users#update'
  # delete 'users/:id', to: 'users#destroy'

  #routes to users controller 
  resources :users, only: [:index, :show, :create, :update, :destroy]

  #routes to artworks controller 
  resources :artworks, only: [:show, :create, :update, :destroy]

  #route for a user to mark their artwork as a favorite
  resources :artworks do 
    patch 'favorite', on: :member 
  end 

  #route to get all the artworks of a user. this returns all the artworks a user owns and all the artworks that have been shared with that user. this will allow a GET request to /users/:user_id/artworks
  resources :users do 
    resources :artworks, only: [:index]
  end 

  #routes to artwork_shares controller 
  resources :artwork_shares, only: [:index, :show, :create, :destroy]

  #route for a user to mark artwork that has been shared with them as a favorite
  resources :artwork_shares do 
    patch 'favorite', on: :member 
  end 

  #routes to comments controller 
  resources :comments, only: [:create, :destroy, :index]
end
