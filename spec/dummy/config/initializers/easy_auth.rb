EasyAuth.config do |c|
  c.oauth2_client :google,   ENV['OAUTH_GOOGLE_CLIENT_ID'],   ENV['OAUTH_GOOGLE_SECRET'],   'https://www.googleapis.com/auth/userinfo.profile'
  c.oauth2_client :facebook, ENV['OAUTH_FACEBOOK_CLIENT_ID'], ENV['OAUTH_FACEBOOK_SECRET'], ''
  c.oauth2_client :github,   ENV['OAUTH_GITHUB_CLIENT_ID'],   ENV['OAUTH_GITHUB_SECRET'],   ''
end
