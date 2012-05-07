module ActionDispatch::Routing
  class Mapper
    def easy_auth_routes
      easy_auth_session_routes
      easy_auth_password_reset_routes
    end

    def easy_auth_session_routes
      get  '/sign_out' => 'sessions#destroy', :as => :sign_out
      get  '/sign_in'  => 'sessions#new',     :as => :sign_in
      post '/sign_in'  => 'sessions#create'
    end

    def easy_auth_password_reset_routes
      get  '/password_reset' => 'password_reset#new', :as => :password_reset
      post '/password_reset' => 'password_reset#create'
      get  '/password_reset/:reset_token' => 'password_reset#edit', :as => :edit_password
      put  '/password_reset/:reset_token' => 'password_reset#update'
    end
  end
end
