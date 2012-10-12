require 'spec_helper'

describe 'Config' do
  before do
    EasyAuth.config do |c|
      c.oauth2_client :google, 'client_id', 'secret', 'scope'
    end
  end

  it 'sets the value to the class instance variable' do
    EasyAuth.oauth2[:google].client_id.should eq 'client_id'
    EasyAuth.oauth2[:google].secret.should    eq 'secret'
    EasyAuth.oauth2[:google].scope.should     eq 'scope'
  end
end
