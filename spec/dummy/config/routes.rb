Rails.application.routes.draw do

  mount EasyAuth::Engine => "/easy_auth"
end
