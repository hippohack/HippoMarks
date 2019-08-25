Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'
  # get 'home/index'

  get '/bookmarks/add', to: 'bookmarks#add', as: 'add_bookmark'
  get '/bookmarks/manage', to: 'bookmarks#manage', as: 'manage_bookmarks'
  get '/bookmarks/import', to: 'bookmarks#import', as: 'import_bookmarks'
  get '/bookmarks/export', to: 'bookmarks#export', as: 'export_bookmarks'
  get '/bookmarks/search', to: 'bookmarks#search', as: 'search_bookmarks'
  resources :bookmarks

  get '/import', to: 'import#index'
  post '/import', to: 'import#index'

  get '/folders/manage', to: 'folders#manage', as: 'manage_folders'
  resources :folders

  get '/about',   to: 'home#index'
  get '/contact', to: 'home#index'

  namespace :api, format: 'json' do
    get '/bookmarks', to: 'bookmarks#index', as: 'bookmarks'
    get '/bookmarks/:bookmark_id/folder', to: 'bookmarks#folder', as: 'folder'
    resources :bookmarks
    resources :folders
    resources :tasks, only: [:index, :create, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
