require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_request do |request|
    # Capybara requests
    URI(request.uri).port == 3999
  end 
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
