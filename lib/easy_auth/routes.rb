module EasyAuth::Routes
  def easy_auth_routes
    get  '/sign_out' => 'sessions#destroy', :as => :sign_out
    easy_auth_o_auth1_routes
    easy_auth_o_auth2_routes
  end

  def easy_auth_o_auth1_routes
    get  '/sign_in/o_auth1/:provider'          => 'sessions#new',    :as => :o_auth1_sign_in,  :defaults => { :identity => :o_auth1 }
    get  '/sign_in/o_auth1/:provider/callback' => 'sessions#create', :as => :o_auth1_callback, :defaults => { :identity => :o_auth1 }
  end

  def easy_auth_o_auth2_routes
    get  '/sign_in/o_auth2/:provider'          => 'sessions#new',    :as => :o_auth2_sign_in,  :defaults => { :identity => :o_auth2 }
    get  '/sign_in/o_auth2/:provider/callback' => 'sessions#create', :as => :o_auth2_callback, :defaults => { :identity => :o_auth2 }
  end
end
