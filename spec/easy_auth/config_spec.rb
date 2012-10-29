require 'spec_helper'

describe 'Config' do
  before do
    EasyAuth.config do |c|
      c.o_auth2_client :google, 'client_id', 'secret', 'scope'
    end
  end

  it 'sets the value to the class instance variable' do
    EasyAuth.o_auth2[:google].client_id.should eq 'client_id'
    EasyAuth.o_auth2[:google].secret.should    eq 'secret'
    EasyAuth.o_auth2[:google].scope.should     eq 'scope'
  end
end
