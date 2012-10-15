require 'spec_helper'

describe PasswordIdentity do
  let(:params) { Hash.new }
  let(:controller) do
    controller = mock('Controller')
    controller.stubs(:params).returns({:password_identity => params})
    controller
  end

  describe 'username' do
    before { create(:password_identity) }
    it { should     have_valid(:username).when('another_test@example.com') }
    it { should_not have_valid(:username).when('test@example.com', 'TEST@EXAMPLE.COM', nil, '') }
  end

  describe 'password' do
    context 'new record' do
      it { should     have_valid(:password).when('password') }
      it { should_not have_valid(:password).when(nil, '') }
    end

    context 'existing record' do
      subject do
        create(:password_identity)
        PasswordIdentity.last
      end
      it { should have_valid(:password).when('password', nil, '') }
    end

    context 'password reset' do
      subject do
        create(:password_identity)
        identity = PasswordIdentity.last
        identity.password_reset = true
        identity
      end
      it { should_not have_valid(:password).when(nil, '') }
    end
  end

  describe '.authenticate' do
    before do
      params.merge!(:username => 'test@example.com')
    end
    context 'correct username and password' do
      before do
        params[:password] = 'password'
        create(:password_identity)
      end
      it 'returns the user' do
        PasswordIdentity.authenticate(controller).should be_instance_of PasswordIdentity
      end
      context 'with remember' do
        before { params[:remember] = true }
        it { PasswordIdentity.authenticate(controller).remember.should be_true }
      end
      context 'without remember' do
        it { PasswordIdentity.authenticate(controller).remember.should be_false }
      end
    end
    context 'correct username bad password' do
      before do
        params[:password] = 'bad'
        create(:password_identity)
      end
      it 'returns nil' do
        PasswordIdentity.authenticate(controller).should be_nil
      end
    end
    context 'bad username and password' do
      before { params.merge!(:username => 'bad@example.com', :password => 'bad') }
      it 'returns nil' do
        PasswordIdentity.authenticate(controller).should be_nil
      end
    end
    context 'no attributes given' do
      it 'returns nil' do
        PasswordIdentity.authenticate(controller).should be_nil
      end
    end
  end

  describe '#generate_remember_token' do
    it 'sets a unique remember token' do
      identity = create(:password_identity, :account => build(:user))
      identity.remember_token.should be_nil
      identity.generate_remember_token!
      identity = PasswordIdentity.last
      identity.remember_token.should_not be_nil
    end
  end

  describe '#password_reset' do
    it 'sets a unique reset token' do
      identity = create(:password_identity, :account => build(:user))
      identity.reset_token.should be_nil
      identity.generate_reset_token!
      identity = PasswordIdentity.last
      identity.reset_token.should_not be_nil
    end
  end
end
