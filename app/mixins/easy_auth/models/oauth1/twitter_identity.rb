module EasyAuth::Models::Oauth1::TwitterIdentity
  def authorize_url
    'https://api.twitter.com/oauth/authenticate'
  end

  private

  def site_url
    'https://api.twitter.com'
  end
end
