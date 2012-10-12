module EasyAuth::Models::Oauth1::TwitterIdentity
  def authorize_url
    'https://api.twitter.com/oauth/authenticate'
  end

  private

  def user_info_url
    'https://api.twitter.com/1.1/account/settings.json'
  end

  def site_url
    'https://api.twitter.com'
  end
end
