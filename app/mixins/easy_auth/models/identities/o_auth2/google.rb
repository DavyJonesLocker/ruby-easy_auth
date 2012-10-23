module EasyAuth::Models::Identities::OAuth2::Google
  def authorize_url
    '/o/oauth2/auth'
  end

  private

  def user_info_url
    'https://www.googleapis.com/oauth2/v1/userinfo'
  end

  def token_url
    '/o/oauth2/token'
  end

  def site_url
    'https://accounts.google.com'
  end
end
