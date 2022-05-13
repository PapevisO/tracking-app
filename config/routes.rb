Rails.application.routes.draw do
  resources :records

  get '/stats', action: :index, controller: 'stats'
  get '/s/:id' => "shortener/shortened_urls#show"

  post '/n', action: :new, controller: 'shortener_new_urls'

  get '/' => 'main#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
