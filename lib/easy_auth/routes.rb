module ActionDispatch::Routing
  class Mapper
    def easy_auth_routes
      get  '/sign_in' => 'sessions#new', :as => :sign_in
      post '/sign_in' => 'sessions#create'
    end
  end
end
