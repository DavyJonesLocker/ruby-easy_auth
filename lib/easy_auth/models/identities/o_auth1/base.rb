require 'oauth'

module EasyAuth::Models::Identities::OAuth1::Base
  def self.included(base)
    base.class_eval do
      serialize :token, Hash
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate(controller)
      oauth_token         = controller.params[:oauth_token]
      oauth_verifier      = controller.params[:oauth_verifier]
      access_token_secret = controller.session.delete('access_token_secret')
      request_token       = OAuth::RequestToken.new(client, oauth_token, access_token_secret)
      token               = request_token.get_access_token(:oauth_verifier => oauth_verifier)
      username            = retrieve_username(token)
      identity            = self.find_or_initialize_by_username username.to_s
      identity.token      = {:token => token.token, :secret => token.secret}
      account             = controller.current_account

      if identity.new_record?
        account = EasyAuth.account_model.create(EasyAuth.account_model.identity_username_attribute => identity.username) if account.nil?
        identity.account = account
      end

      identity.save!
      identity
    end

    def new_session(controller)
      controller.redirect_to authenticate_url(controller.o_auth1_callback_url(:provider => provider), controller.session)
    end

    def get_access_token(identity)
      OAuth::AccessToken.new client, identity.token[:token], identity.token[:secret]
    end

    private

    def token_options(callback_url)
      { :redirect_uri => callback_url }
    end

    def client_options
      { :site => site_url, :authorize_path => authorize_path }
    end

    def provider
      raise NotImplementedError
    end

    def retrieve_username(token)
      raise NotImplementedError
    end

    def client
      @client ||= OAuth::Consumer.new(client_id, secret, client_options)
    end

    def authenticate_url(callback_url, session)
      request_token = client.get_request_token(:oauth_callback => callback_url)
      session['access_token_secret'] = request_token.secret
      request_token.authorize_url(:oauth_callback => callback_url)
    end

    def authorize_path
      raise NotImplementedError
    end

    def site_url
      raise NotImplementedError
    end

    def scope
      settings.scope
    end

    def client_id
      settings.client_id
    end

    def secret
      settings.secret
    end

    def settings
      EasyAuth.o_auth1[provider]
    end

    def provider
      self.to_s.split('::').last.underscore.to_sym
    end
  end

  def get_access_token
    self.class.get_access_token self
  end
end
