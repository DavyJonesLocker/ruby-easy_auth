Rails.application.routes.draw do
  def easy_auth_test_identity_routes
    get  '/sign_in'  => 'sessions#new',    :as => :sign_in, :defaults => { :identity => 'test_identity' }
    post '/sign_in'  => 'sessions#create', :defaults => { :identity => 'test_identity' }
  end

  easy_auth_routes

  get '/profile'   => 'profile#show',   :as => :profile
  get '/dashboard' => 'dashboard#show', :as => :dashboard

  post '/authenticated_posts'     => 'authenticated_posts#create'
  get '/landings'                 => 'landing#index'
  root :to => 'landing#show'
end
