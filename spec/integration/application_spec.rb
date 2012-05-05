require 'spec_helper'

describe Dummy::Application do
  it 'automatically sets the filtered password parameters' do
    Dummy::Application.config.filter_parameters.should include(:password)
  end
end
