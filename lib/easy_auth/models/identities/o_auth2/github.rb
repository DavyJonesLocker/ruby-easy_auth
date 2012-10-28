module EasyAuth::Models::Identities::OAuth2::Github
  def authorize_url
    '/login/oauth/authorize'
  end

  private

  def user_info_url
    'https://api.github.com/user'
  end

  def token_url
    '/login/oauth/access_token'
  end

  def site_url
    'https://github.com'
  end
end
