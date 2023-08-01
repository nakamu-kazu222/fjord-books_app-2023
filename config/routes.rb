Rails.application.routes.draw do
  resources :books

  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/show" => "users#show"


  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "books#index"
end
