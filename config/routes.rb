Rails.application.routes.draw do
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  root 'bootstrap#index'
  get 'bracket', to:  'bootstrap#bracket'
  get 'panel', to: 'bootstrap#panel'
  get 'panel/edit', to: 'bootstrap#panel_edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
