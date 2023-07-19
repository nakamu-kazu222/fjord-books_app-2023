Rails.application.routes.draw do
  resources :books

  get '/blogs', to: 'blogs#index', as: 'blogs'
  get '/blogs/new', to: 'blogs#new', as: 'new_blog'
  post '/blogs', to: 'blogs#create'
  get '/blogs/:id', to: 'blogs#show', as: 'blog'
  get '/blogs/:id/edit', to: 'blogs#edit', as: 'edit_blog'
  patch '/blogs/:id', to: 'blogs#update'
  delete '/blogs/:id', to: 'blogs#destroy'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
