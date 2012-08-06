require 'spec_helper'

describe Identity do
  describe 'username' do
    before { create(:identity) }
    it { should     have_valid(:username).when('another_test@example.com') }
    it { should_not have_valid(:username).when('test@example.com', nil, '') }
  end

  describe 'password' do
    context 'new record' do
      it { should     have_valid(:password).when('password') }
      it { should_not have_valid(:password).when(nil, '') }
    end

    context 'existing record' do
      subject do
        create(:identity)
        Identity.last
      end
      it { should have_valid(:password).when('password', nil, '') }
    end

    context 'password reset' do
      subject do
        create(:identity)
        identity = Identity.last
        identity.password_reset = true
        identity
      end
      it { should_not have_valid(:password).when(nil, '') }
    end
  end

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
        it { Identity.authenticate(:username => 'test@example.com', :password => 'password').remember.should be_false }
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

  describe '#generate_remember_token' do
    it 'sets a unique remember token' do
      identity = create(:identity, :account => build(:user))
      identity.remember_token.should be_nil
      identity.generate_remember_token!
      identity = Identity.last
      identity.remember_token.should_not be_nil
    end
  end

  describe '#password_reset' do
    it 'sets a unique reset token' do
      identity = create(:identity, :account => build(:user))
      identity.reset_token.should be_nil
      identity.generate_reset_token!
      identity = Identity.last
      identity.reset_token.should_not be_nil
    end
  end
end
