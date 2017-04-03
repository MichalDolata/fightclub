Rails.application.routes.draw do
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
