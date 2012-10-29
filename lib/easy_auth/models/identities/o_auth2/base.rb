require 'oauth2'

module EasyAuth::Models::Identities::OAuth2::Base
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate(controller)
      callback_url   = controller.o_auth2_callback_url(:provider => provider)
      code           = controller.params[:code]
      token          = client.auth_code.get_token(code, token_options(callback_url))
      user_info      = get_user_info(token)
      identity       = self.find_or_initialize_by_username user_info['id'].to_s
      identity.token = token.token
      account        = controller.current_account

      if identity.new_record?
        account = EasyAuth.account_model.create(EasyAuth.account_model.identity_username_attribute => identity.username) if account.nil?
        identity.account = account
      end

      identity.save!
      identity
    end

    def new_session(controller)
      controller.redirect_to authenticate_url(controller.o_auth2_callback_url(:provider => provider))
    end

    def get_access_token(identity)
      OAuth2::AccessToken.new client, identity.token
    end

    private

    def token_options(callback_url)
      { :redirect_uri => callback_url }
    end

    def get_user_info(token)
      ActiveSupport::JSON.decode(token.get(user_info_url).body)
    end

    def provider
      raise NotImplementedError
    end

    def client
      @client ||= OAuth2::Client.new(client_id, secret, :site => site_url, :authorize_url => authorize_url, :token_url => token_url)
    end

    def authenticate_url(callback_url)
      client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => scope)
    end

    def user_info_url
      raise NotImplementedError
    end

    def authorize_url
      raise NotImplementedError
    end

    def token_url
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
      EasyAuth.o_auth2[provider]
    end

    def provider
      self.to_s.split('::').last.underscore.to_sym
    end
  end

  def get_access_token
    self.class.get_access_token self
  end
end
