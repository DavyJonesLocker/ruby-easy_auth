class User < ActiveRecord::Base
  include EasyAuth::Models::Account
end
