Rails.application.routes.draw do
    root 'static#home'

    get '/tournaments/search' => 'tournaments#search', as: :tournament_search
    get '/players/search' => 'players#search', as: :player_search
    get '/players/recommendation' => 'teams#players_recommendation', as: :players_recommendation
    get '/teams/recommendation' => 'players#teams_recommendation', as: :teams_recommendation

    get 'teams/search' => 'teams#search', as: :teams_search

    get '/teams/:id/enquiries' => 'enquiries#enquiries', as: :enquiries
    
    get '/users/:id/enquiries' => 'enquiries#teams_enquiries', as: :teams_enquiries

    resources :sessions

    resources :users

    resources :teams
    get '/teams/:id/join' => 'teams#join', as: :join_team


    resources :tournaments, except: :show

    resources :happenings, only: :index
    get '/happenings/search' => 'happenings#search', as: :happening_search

    resources :heroes, only: [:index, :show]

    resources :players

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # route to create session after steam authentication
    match '/auth/:provider/callback', to: 'sessions#create_from_omniauth', via: :all

    # use our session controller instead of clearance session controller
    delete "/sign_out" => "sessions#destroy", as: :sign_out
    post '/sign_up' => "sessions#sign_up_oauth", as: :sign_up


    # get '/edit/:id' => "users#edit", as: :edit_user
    # patch '/update/:id' => "users#update", as: :update_user

end
