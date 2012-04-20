Rails.application.routes.draw do
  easy_auth_routes

  get '/dashboard' => 'dashboard#show', :as => :dashboard
  root :to => 'landing#show'
end
