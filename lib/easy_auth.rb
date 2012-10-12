require 'bcrypt'
require 'easy_auth/engine'
require 'easy_auth/routes'

module EasyAuth
  def self.identity_model
    Identity
  end

  def self.account_model
    User
  end

  def self.password_identity_model(controller = nil)
    PasswordIdentity
  end

  def self.oauth_identity_model(controller)
    send("oauth_#{controller.params[:provider]}_identity_model", controller)
  end

  def self.oauth_google_identity_model(controller)
    Oauth::GoogleIdentity
  end

  def self.oauth_facebook_identity_model(controller)
    Oauth::FacebookIdentity
  end

  def self.authenticate(controller)
    if identity_model = find_identity_model(controller)
      identity_model.authenticate(controller)
    end
  end

  def self.new_session(controller)
    identity_model = find_identity_model(controller)
    identity_model.new_session(controller)
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

  private

  def self.find_identity_model(controller)
    send("#{controller.params[:identity]}_identity_model", controller)
  end
end
