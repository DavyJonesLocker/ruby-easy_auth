require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/easy_auth/setup_generator'

describe EasyAuth::SetupGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates config/initializers/easy_auth.rb' do
    File.exist?(File.expand_path('config/initializers/easy_auth.rb', destination_root)).should be_true
  end
end
