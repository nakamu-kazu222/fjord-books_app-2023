Rails.application.routes.draw do
  resources :books
  
  scope module: :admin, as: :admin do
    resources :blogs
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
