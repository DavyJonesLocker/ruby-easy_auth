module EasyAuth::Models::Oauth::GoogleIdentity
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def authenticate_url(callback_url)
      client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => EasyAuth.oauth[:google].scope)
    end

    def authenticate(controller)
      account = controller.current_account
      callback_url = controller.oauth_callback_url(:provider => :google)
      code = controller.params[:code]
      token = client.auth_code.get_token(code, :redirect_uri => callback_url)
      user_info_response = token.get 'https://www.googleapis.com/oauth2/v1/userinfo'
      user_info = ActiveSupport::JSON.decode user_info_response.body

      identity = self.find_or_initialize_by_username user_info['id']

      identity.token = token.token

      if identity.new_record? && account.nil?
        account = EasyAuth.account_model.create(EasyAuth.account_model.identity_username_attribute => identity.username)
      end

      if identity.new_record?
        identity.account = account
      end

      identity.save!

      identity
    end

    def new_session(controller)
      controller.redirect_to authenticate_url(controller.oauth_callback_url(:provider => :google))
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
