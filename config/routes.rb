Rails.application.routes.draw do
  resources :books

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/index" => "users#index", as: :users
  get "users/:id" => "users#show", as: :user

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "books#index"
end
