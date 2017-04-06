Rails.application.routes.draw do
  resources :tournaments do
    post 'add_team', on: :member, to: 'tournaments#add_team'
    post 'generate', on: :member, to: 'tournaments#generate'
  end

  resources :teams

  get 'sessions/new'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy'

  root 'bootstrap#index'
  get 'bracket', to:  'bootstrap#bracket'
  get 'panel', to: 'bootstrap#panel'
  get 'panel/edit', to: 'bootstrap#panel_edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
