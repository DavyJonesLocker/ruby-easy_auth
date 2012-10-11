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

  def self.password_identity_model
    PasswordIdentity
  end

  def self.google_oauth_identity_model
    GoogleIdentity
  end

  def self.authenticate(controller)
    if controller.params[:identity] == :password
      EasyAuth.password_identity_model.authenticate(controller.params[:password_identity])
    elsif controller.params[:identity] == :oauth
      EasyAuth.send("#{controller.params[:provider]}_oauth_identity_model").authenticate(controller.current_account,
                                                                        controller.oauth_callback_url(:provider => controller.params[:provider]),
                                                                        controller.params[:code])
    end
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
