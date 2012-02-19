$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'easy_auth/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'easy_auth'
  s.version     = EasyAuth::VERSION
  s.authors     = ['Brian Cardarella']
  s.email       = ['brian@dockyard.com', 'bcardarella@gmail.com']
  s.homepage    = 'https://github.com/dockyard/easy_auth'
  s.summary     = 'EasyAuth.'
  s.description = 'EasyAuth.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 3.2.1'
  # s.add_dependency 'jquery-rails'

  s.add_development_dependency 'sqlite3'
end
