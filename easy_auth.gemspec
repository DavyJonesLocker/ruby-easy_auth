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

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 3.2.1'
  s.add_dependency 'bcrypt-ruby', '~> 3.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-email'
  s.add_development_dependency 'valid_attribute'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'bourne'
  s.add_development_dependency 'launchy'
  if RUBY_VERSION > '1.9' && RUBY_ENGINE == 'ruby'
    s.add_development_dependency 'debugger'
  end
end
