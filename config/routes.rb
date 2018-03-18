Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/" => "users#top"
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"

  get "users/:id/interviews" => "interviews#index"
  get "users/:id/interviews/new" => "interviews#new"
  post "users/:id/interviews/create" => "interviews#create"
  get "users/:id/interviews/:id/edit" => "interviews#edit"
  post "users/:id/interviews/:id/update" => "interviews#update"
  get "users/:id/interviews/:id/status" => "interviews#status"
  post "users/:id/interviews/:id/status_update" => "interviews#status_update"
  post "users/:id/interviews/:id/destroy" => "interviews#destroy"
end
