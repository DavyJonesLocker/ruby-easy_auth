require 'spec_helper'

describe EasyAuth::Identity do
   describe '.authenticate' do
    context 'correct username and password' do
      before { create(:identity) }
      it 'returns the user' do
        EasyAuth::Identity.authenticate(:username => 'test@example.com', :password => 'password').should be_instance_of EasyAuth::Identity
      end
    end
    context 'correct username bad password' do
      before { create(:identity) }
      it 'returns nil' do
        EasyAuth::Identity.authenticate(:username => 'test@example.com', :password => 'bad').should be_nil
      end
    end
    context 'bad username and password' do
      it 'returns nil' do
        EasyAuth::Identity.authenticate(:username => 'bad@example.com', :password => 'bad').should be_nil
      end
    end
    context 'no attributes given' do
      it 'returns nil' do
        EasyAuth::Identity.authenticate.should be_nil
      end
    end
  end

  describe '#generate_session_token!' do
    it 'sets a unique session token' do
      identity = create(:identity, :account => build(:user))
      identity.session_token.should be_nil
      identity.generate_session_token!
      identity = EasyAuth::Identity.last
      identity.session_token.should_not be_nil
    end
  end

  describe '#password_reset' do
    it 'sets a unique reset token' do
      identity = create(:identity, :account => build(:user))
      identity.reset_token.should be_nil
      identity.password_reset
      identity = EasyAuth::Identity.last
      identity.reset_token.should_not be_nil
    end
  end
end
