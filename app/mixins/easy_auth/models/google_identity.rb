require 'oauth2'
module EasyAuth::Models::GoogleIdentity
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate_url(callback_url)
      client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => EasyAuth.oauth[:google].scope)
    end

    def authenticate(callback_url, code)
      token = client.auth_code.get_token(code, :redirect_uri => callback_url)
      user_info_response = token.get 'https://www.googleapis.com/oauth2/v1/userinfo'
      user_info = ActiveSupport::JSON.decode user_info_response.body

      identity = self.find_or_initialize_by_username user_info['id']

      identity.token = token.token

      identity
    end

    private

    def client
      @client ||= OAuth2::Client.new(EasyAuth.oauth[:google].client_id, EasyAuth.oauth[:google].secret, :site => site_url,
                                     :authorize_url => authorize_url, :token_url => token_url)
    end

    def authorize_url
      '/o/oauth2/auth'
    end

    def token_url
      '/o/oauth2/token'
    end

    def site_url
      'https://accounts.google.com'
    end
  end
end
