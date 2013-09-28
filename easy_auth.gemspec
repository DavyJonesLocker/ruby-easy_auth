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

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency     'rails', '~> 4.0.0'
  s.add_runtime_dependency     'postgres_ext'

  s.add_development_dependency 'rails',    '~> 4.0.0'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'database_cleaner', '~> 1.0.1'
  s.add_development_dependency 'valid_attribute'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
  s.add_development_dependency 'factory_girl', '~> 2.6.0'
  s.add_development_dependency 'mocha', '~> 0.10.5'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'generator_spec'
end
