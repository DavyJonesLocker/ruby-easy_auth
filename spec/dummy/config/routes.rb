Rails.application.routes.draw do
  easy_auth_routes

  get '/dashboard' => 'dashboard#show', :as => :dashboard
end
