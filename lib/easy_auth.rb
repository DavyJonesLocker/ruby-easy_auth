require 'bcrypt'
require 'easy_auth/engine'
require 'easy_auth/routes'

module EasyAuth
  def self.identity_model
    Identity
  end

  def self.password_identity_model
    PasswordIdentity
  end

  def self.google_identity_model
    GoogleIdentity
  end

  class << self
    attr_accessor :oauth
  end

  self.oauth = {}

  def self.config(&block)
    yield self
  end

  def self.oauth_client(provider, client_id, secret, scope)
    oauth[provider] = OpenStruct.new :client_id => client_id, :secret => secret, :scope => scope
  end
end
