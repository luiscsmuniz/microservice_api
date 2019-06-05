Rails.application.routes.draw do
  resources :tasks

  get '/api/tasks/', to: 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
