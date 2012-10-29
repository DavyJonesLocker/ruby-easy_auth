$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'easy_auth/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'easy_auth'
  s.version     = EasyAuth::VERSION
  s.authors     = ['Brian Cardarella', 'Dan McClain']
  s.email       = ['brian@dockyard.com', 'bcardarella@gmail.com', 'rubygems@danmcclain.net']
  s.homepage    = 'https://github.com/dockyard/easy_auth'
  s.summary     = 'EasyAuth'
  s.description = 'EasyAuth'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.md']

  s.add_dependency 'rails',       '~> 3.2.1'
  s.add_dependency 'bcrypt-ruby', '~> 3.0.0'
  s.add_dependency 'oauth2',      '~> 0.8.0'
  s.add_dependency 'oauth',       '~> 0.4.7'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'capybara-email'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'valid_attribute'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
  s.add_development_dependency 'factory_girl', '~> 2.6.0'
  s.add_development_dependency 'bourne'
  s.add_development_dependency 'launchy'
end
