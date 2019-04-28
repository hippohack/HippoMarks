Rails.application.routes.draw do
  get 'home/index'
  namespace :api, format: 'json' do
    resources :tasks, only: [:index, :create, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
