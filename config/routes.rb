Rails.application.routes.draw do
    root 'static#home'
    resources :sessions
    resources :users
    resources :teams
    resources :tournaments
    resources :happenings
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # route to create session after steam authentication
    match '/auth/:provider/callback', to: 'sessions#create_from_omniauth', via: :all

    # use our session controller instead of clearance session controller
    delete "/sign_out" => "sessions#destroy", as: :sign_out
    post '/sign_up' => "sessions#sign_up_oauth", as: :sign_up


    # get '/edit/:id' => "users#edit", as: :edit_user
    # patch '/update/:id' => "users#update", as: :update_user

end
