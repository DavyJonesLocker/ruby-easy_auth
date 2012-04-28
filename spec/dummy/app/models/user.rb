class User < ActiveRecord::Base
  include EasyAuth::Account
  attr_accessible :email
end
