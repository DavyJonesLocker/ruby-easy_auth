require 'spec_helper'

describe Identity do
   describe '.authenticate' do
    context 'correct username and password' do
      before { create(:identity) }
      it 'returns the user' do
        Identity.authenticate(:username => 'test@example.com', :password => 'password').should be_instance_of Identity
      end
      context 'with remember' do
        it { Identity.authenticate(:username => 'test@example.com', :password => 'password', :remember => true).remember.should be_true }
      end
      context 'without remember' do
        it { Identity.authenticate(:username => 'test@example.com', :password => 'password').remember.should be_nil }
      end
    end
    context 'correct username bad password' do
      before { create(:identity) }
      it 'returns nil' do
        Identity.authenticate(:username => 'test@example.com', :password => 'bad').should be_nil
      end
    end
    context 'bad username and password' do
      it 'returns nil' do
        Identity.authenticate(:username => 'bad@example.com', :password => 'bad').should be_nil
      end
    end
    context 'no attributes given' do
      it 'returns nil' do
        Identity.authenticate.should be_nil
      end
    end
  end

  describe '#generate_session_token!' do
    it 'sets a unique session token' do
      identity = create(:identity, :account => build(:user))
      identity.session_token.should be_nil
      identity.generate_session_token!
      identity = Identity.last
      identity.session_token.should_not be_nil
    end
  end

  describe '#password_reset' do
    it 'sets a unique reset token' do
      identity = create(:identity, :account => build(:user))
      identity.reset_token.should be_nil
      identity.password_reset
      identity = Identity.last
      identity.reset_token.should_not be_nil
    end
  end

  describe '#generate_remember_token' do
    context 'remember_me is true' do
      it 'sets a unique remember token' do
        identity = create(:identity, :account => build(:user))
        identity.remember = true
        identity.remember_token.should be_nil
        identity.generate_remember_token!
        identity = Identity.last
        identity.remember_token.should_not be_nil
      end
    end
    context 'remember_me is false' do
      it 'sets a unique remember token' do
        identity = create(:identity, :account => build(:user))
        identity.remember_token.should be_nil
        identity.generate_remember_token!
        identity = Identity.last
        identity.remember_token.should be_nil
      end
    end
  end
end
