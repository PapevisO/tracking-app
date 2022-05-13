Rails.application.routes.draw do
  resources :records

  get '/stats', action: :index, controller: 'stats'
  get '/s/:id' => "shortener/shortened_urls#show"

  get '/urls/new' => 'shortener_new_urls#new'
  post '/urls/new' => 'shortener_new_urls#create'

  get '/' => 'main#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
