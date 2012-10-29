require 'easy_auth/engine'
require 'easy_auth/version'
require 'active_support'
require 'bcrypt'

module EasyAuth
  extend ActiveSupport::Autoload

  autoload :Controllers
  autoload :Mailers
  autoload :Models
  autoload :Routes
  autoload :TokenGenerator

  def self.identity_model
    EasyAuth::Identity
  end

  def self.account_model
    User
  end

  def self.password_identity_model(controller = nil)
    EasyAuth::Identities::Password
  end

  def self.o_auth2_identity_model(controller)
    send("o_auth2_#{controller.params[:provider]}_identity_model", controller)
  end

  def self.o_auth1_identity_model(controller)
    send("o_auth1_#{controller.params[:provider]}_identity_model", controller)
  end

  def self.o_auth1_twitter_identity_model(controller)
    EasyAuth::Identities::OAuth1::Twitter
  end

  def self.o_auth1_linkedin_identity_model(controller)
    EasyAuth::Identities::OAuth1::LinkedIn
  end

  def self.o_auth2_google_identity_model(controller)
    EasyAuth::Identities::OAuth2::Google
  end

  def self.o_auth2_facebook_identity_model(controller)
    EasyAuth::Identities::OAuth2::Facebook
  end

  def self.o_auth2_github_identity_model(controller)
    EasyAuth::Identities::OAuth2::Github
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
    attr_accessor :o_auth1, :o_auth2
  end

  self.o_auth1 = {}
  self.o_auth2 = {}

  def self.config(&block)
    yield self
  end

  def self.o_auth1_client(provider, client_id, secret, scope = '')
    o_auth1[provider] = o_auth_client(client_id, secret, scope)
  end

  def self.o_auth2_client(provider, client_id, secret, scope = '')
    o_auth2[provider] = o_auth_client(client_id, secret, scope)
  end

  private

  def self.o_auth_client(client_id, secret, scope = '')
    OpenStruct.new :client_id => client_id, :secret => secret, :scope => scope || ''
  end

  def self.find_identity_model(controller)
    send("#{controller.params[:identity]}_identity_model", controller)
  end
end

ActionDispatch::Routing::Mapper.send(:include, EasyAuth::Routes)
