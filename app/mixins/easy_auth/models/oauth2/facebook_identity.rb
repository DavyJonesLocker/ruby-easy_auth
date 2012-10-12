module EasyAuth::Models::Oauth2::FacebookIdentity
  def authorize_url
    '/dialog/oauth'
  end

  private

  def token_options(callback_url)
    super.merge(:parse => :query)
  end

  def user_info_url
    'https://graph.facebook.com/me'
  end

  def token_url
    'https://graph.facebook.com/oauth/access_token'
  end

  def site_url
    'https://www.facebook.com'
  end
end
