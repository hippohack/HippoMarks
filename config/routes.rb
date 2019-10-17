Rails.application.routes.draw do
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions'
  }
  root to: 'home#index'
  get '/welcome', to: 'home#welcome', as: 'welcome'

  get '/bookmarks/add', to: 'bookmarks#add', as: 'add_bookmark'
  get '/bookmarks/:id/popup_edit', to: 'bookmarks#popup_edit', as: 'popup_edit_bookmark'
  get '/bookmarks/replace_img', to: 'bookmarks#replace_img', as: 'replace_img'
  get '/bookmarks/manage', to: 'bookmarks#manage', as: 'manage_bookmarks'
  get '/bookmarks/import', to: 'bookmarks#import', as: 'import_bookmarks'
  get '/bookmarks/export', to: 'bookmarks#export', as: 'export_bookmarks'
  get '/bookmarks/search', to: 'bookmarks#search', as: 'search_bookmarks'
  resources :bookmarks

  get '/import', to: 'import#index'
  post '/import', to: 'import#index'

  get '/folders/manage', to: 'folders#manage', as: 'manage_folders'
  resources :folders
  resources :profiles

  put '/settings', to: 'settings#update', as: 'settings_update'
  patch '/settings/item_sort', to: 'settings#item_sort', as: 'item_sort'
  resources :settings

  get '/about',   to: 'home#index'
  get '/contact', to: 'home#index'

  namespace :api, format: 'json' do
    get '/bookmarks', to: 'bookmarks#index', as: 'bookmarks'
    get '/bookmarks/:bookmark_id/folder', to: 'bookmarks#folder', as: 'folder'
    patch '/bookmarks/:bookmark_id/increment_impression', to: 'bookmarks#increment_impression'
    resources :bookmarks
    get '/folders/many_visits', to: 'folders#many_visits', as: 'many_visits'
    get '/folders/history', to: 'folders#history', as: 'history'
    resources :folders
    resources :tasks, only: [:index, :create, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
