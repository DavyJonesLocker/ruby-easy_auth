EasyAuth.config do |c|
  c.oauth_client :google, ENV['GOOGLE_OAUTH_CLIENT_ID'], ENV['GOOGLE_OAUTH_SECRET'], ENV['GOOGLE_OAUTH_SCOPE']
end
