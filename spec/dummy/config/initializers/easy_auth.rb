EasyAuth.config do |c|
  c.oauth_client :google,   ENV['OAUTH_GOOGLE_CLIENT_ID'],   ENV['OAUTH_GOOGLE_SECRET'],   'https://www.googleapis.com/auth/userinfo.profile'
  c.oauth_client :facebook, ENV['OAUTH_FACEBOOK_CLIENT_ID'], ENV['OAUTH_FACEBOOK_SECRET'], ''
end
