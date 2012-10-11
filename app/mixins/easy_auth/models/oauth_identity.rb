require 'oauth2'

module EasyAuth::Models::OauthIdentity
  def authenticate_url(callback_url)
    client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => scope)
  end

  def authenticate(controller)
    raise NotImplementedError
  end

  def new_session(controller)
    controller.redirect_to authenticate_url(controller.oauth_callback_url(:provider => provider))
  end

  private

  def provider
    raise NotImplementedError
  end

  def client
    @client ||= OAuth2::Client.new(client_id, secret, :site => site_url, :authorize_url => authorize_url, :token_url => token_url)
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
    EasyAuth.oauth[provider]
  end

  def provider
    self.to_s.split('::').last.match(/(\w+)Identity/)[1].underscore.to_sym
  end
end
