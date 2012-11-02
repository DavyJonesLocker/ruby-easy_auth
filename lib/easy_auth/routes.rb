module EasyAuth::Routes
  def easy_auth_routes
    get  '/sign_out' => 'sessions#destroy', :as => :sign_out
    methods.grep(/easy_auth_\w+_routes/).each do |routes|
      send(routes)
    end
  end
end
