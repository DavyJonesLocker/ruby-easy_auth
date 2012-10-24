require 'bcrypt'
require 'easy_auth/engine'
require 'easy_auth/routes'

module EasyAuth
  def self.identity_model
    EasyAuth::Identity
  end

  def self.account_model
    User
  end

  def self.password_identity_model(controller = nil)
    EasyAuth::Identities::Password
  end

  def self.oauth2_identity_model(controller)
    send("oauth2_#{controller.params[:provider]}_identity_model", controller)
  end

  def self.oauth1_identity_model(controller)
    send("oauth1_#{controller.params[:provider]}_identity_model", controller)
  end

  def self.oauth1_twitter_identity_model(controller)
    EasyAuth::Identities::OAuth1::Twitter
  end

  def self.oauth1_linkedin_identity_model(controller)
    EasyAuth::Identities::OAuth1::LinkedIn
  end

  def self.oauth2_google_identity_model(controller)
    EasyAuth::Identities::OAuth2::Google
  end

  def self.oauth2_facebook_identity_model(controller)
    EasyAuth::Identities::OAuth2::Facebook
  end

  def self.oauth2_github_identity_model(controller)
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
    attr_accessor :oauth1, :oauth2
  end

  self.oauth1 = {}
  self.oauth2 = {}

  def self.config(&block)
    yield self
  end

  def self.oauth2_client(provider, client_id, secret, scope)
    oauth2[provider] = OpenStruct.new :client_id => client_id, :secret => secret, :scope => scope
  end

  def self.oauth1_client(provider, client_id, secret, scope)
    oauth1[provider] = OpenStruct.new :client_id => client_id, :secret => secret, :scope => scope
  end

  private

  def self.find_identity_model(controller)
    send("#{controller.params[:identity]}_identity_model", controller)
  end
end
