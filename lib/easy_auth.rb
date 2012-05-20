require 'bcrypt'
require 'easy_auth/engine'
require 'easy_auth/routes'

module EasyAuth
  def self.identity_model
    Identity
  end
end
