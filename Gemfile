source "http://rubygems.org"

# Only install appropriate ruby debugger if we are not on travis
unless ENV['CI']
  if RUBY_VERSION >= '1.9.2' && RUBY_ENGINE == 'ruby'
    gem 'debugger'
  end
  if RUBY_VERSION == '1.8.7'
    gem 'ruby-debug'
  end
end
gemspec
gem "jquery-rails"
