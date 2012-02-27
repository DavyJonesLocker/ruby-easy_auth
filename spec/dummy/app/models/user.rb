class User < ActiveRecord::Base
  include EasyAuth::Account
end
