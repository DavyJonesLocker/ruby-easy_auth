module EasyAuth::Models::Oauth1::LinkedinIdentity
  def authorize_path
    '/uas/oauth/authenticate'
  end

  private

  def site_url
    'https://api.linkedin.com'
  end

  def retrieve_username(token)
    info = ActiveSupport::JSON.decode(token.get('http://api.linkedin.com/v1/people/~?format=json').body)
    uri = URI.parse info['siteStandardProfileRequest']['url']
    query_hash = CGI.parse uri.query
    query_hash['key'].first
  end

  def client_options
    super.merge(:request_token_path => "/uas/oauth/requestToken?scope=#{scope}",
                :access_token_path  => '/uas/oauth/accessToken')
  end
end
