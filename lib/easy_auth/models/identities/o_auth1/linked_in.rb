module EasyAuth::Models::Identities::OAuth1::LinkedIn
  def authorize_path
    '/uas/oauth/authenticate'
  end

  private

  def site_url
    'https://api.linkedin.com'
  end

  def retrieve_username(token)
    info = ActiveSupport::JSON.decode(token.get('http://api.linkedin.com/v1/people/~?format=json').body)
    uri  = URI.parse info['siteStandardProfileRequest']['url']
    CGI.parse(uri.query)['key'].first
  end

  def client_options
    super.merge(:request_token_path => "/uas/oauth/requestToken?scope=#{scope}",
                :access_token_path  => '/uas/oauth/accessToken')
  end
end
