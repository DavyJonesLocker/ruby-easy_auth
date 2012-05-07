class User < ActiveRecord::Base
  include EasyAuth::Models::Account
  attr_accessible :email
end
