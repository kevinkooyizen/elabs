Rails.application.routes.draw do
    root 'static#home'
    resources :users
    resources :teams
    resources :tournaments
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # route to create session after steam authentication
    match '/auth/:provider/callback', to: 'sessions#create_from_omniauth', via: :all


end
