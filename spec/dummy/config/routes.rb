Rails.application.routes.draw do
  easy_auth_routes

  get '/profile'   => 'profile#show',   :as => :profile
  get '/dashboard' => 'dashboard#show', :as => :dashboard
  root :to => 'landing#show'
end
