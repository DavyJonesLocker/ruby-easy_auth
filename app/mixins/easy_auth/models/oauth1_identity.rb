require 'oauth'

module EasyAuth::Models::Oauth1Identity
  def authenticate(controller)
    callback_url   = controller.oauth1_callback_url(:provider => provider)
    oauth_token    = controller.params[:oauth_token]
    request_token  = OAuth::RequestToken.new(client, oauth_token)
    token          = request_token.get_access_token
    identity       = self.find_or_initialize_by_username token.params[:screen_name]
    identity.token = {:token => token.token, :secret => token.secret}
    account        = controller.current_account

    if identity.new_record?
      account = EasyAuth.account_model.create(EasyAuth.account_model.identity_username_attribute => identity.username) if account.nil?
      identity.account = account
    end

    identity.save!
    identity
  end

  def new_session(controller)
    controller.redirect_to authenticate_url(controller.oauth1_callback_url(:provider => provider))
  end

  private

  def token_options(callback_url)
    { :redirect_uri => callback_url }
  end


  def provider
    raise NotImplementedError
  end

  def client
    @client ||= OAuth::Consumer.new(client_id, secret, :site => site_url, :authorize_url => authorize_url)
  end

  def authenticate_url(callback_url)
    request_token = client.get_request_token(:oauth_callback => callback_url)
    request_token.authorize_url(:oauth_callback => callback_url)
  end

  def authorize_url
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
    EasyAuth.oauth1[provider]
  end

  def provider
    self.to_s.split('::').last.match(/(\w+)Identity/)[1].underscore.to_sym
  end
end
