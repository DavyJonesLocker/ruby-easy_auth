EasyAuth.config do |c|
  c.o_auth1_client :twitter,   ENV['OAUTH_TWITTER_CLIENT_ID'],  ENV['OAUTH_TWITTER_SECRET']
  c.o_auth1_client :linked_in, ENV['OAUTH_LINKEDIN_CLIENT_ID'], ENV['OAUTH_LINKEDIN_SECRET']

  c.o_auth2_client :google,    ENV['OAUTH_GOOGLE_CLIENT_ID'],   ENV['OAUTH_GOOGLE_SECRET'], 'https://www.googleapis.com/auth/userinfo.profile'
  c.o_auth2_client :facebook,  ENV['OAUTH_FACEBOOK_CLIENT_ID'], ENV['OAUTH_FACEBOOK_SECRET']
  c.o_auth2_client :github,    ENV['OAUTH_GITHUB_CLIENT_ID'],   ENV['OAUTH_GITHUB_SECRET']
end
