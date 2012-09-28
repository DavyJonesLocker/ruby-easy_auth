require 'spec_helper'

describe 'Config' do
  before do
    EasyAuth.config do |c|
      c.oauth_client :google, 'client_id', 'secret', 'scope'
    end
  end

  it 'sets the value to the class instance variable' do
    EasyAuth.oauth[:google].client_id.should eq 'client_id'
    EasyAuth.oauth[:google].secret.should    eq 'secret'
    EasyAuth.oauth[:google].scope.should     eq 'scope'
  end
end
