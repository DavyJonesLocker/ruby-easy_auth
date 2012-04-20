class User < ActiveRecord::Base
  def self.easy_auth_username; :email; end
  include EasyAuth::Account
  attr_accessible :email
end
