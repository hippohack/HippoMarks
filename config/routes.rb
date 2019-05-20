Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'
  # get 'home/index'

  get '/bookmarks/add', to: 'bookmarks#add', as: 'add_bookmark'
  get '/bookmarks/manage', to: 'bookmarks#manage', as: 'manage_bookmarks'
  get '/bookmarks/import', to: 'bookmarks#import', as: 'import_bookmarks'
  get '/bookmarks/export', to: 'bookmarks#export', as: 'export_bookmarks'
  resources :bookmarks

  get '/folders/manage', to: 'folders#manage', as: 'manage_folders'
  resources :folders

  get '/about',   to: 'home#index'
  get '/contact', to: 'home#index'

  namespace :api, format: 'json' do
    get '/bookmarks', to: 'bookmarks#index', as: 'bookmarks'
    get '/bookmarks/:folder_id/folder_items', to: 'bookmarks#folder_items', as: 'folder_items'
    resources :bookmarks
    resources :tasks, only: [:index, :create, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
