require 'spec_helper'

describe EasyAuth::Models::Account do
  context '.identity_username_attribute' do
    before do
      class TestUser; end
      TestUser.stubs(:has_many)
      TestUser.stubs(:before_create)
      TestUser.stubs(:before_update)
      TestUser.stubs(:validates)
      TestUser.stubs(:attr_accessible)
    end

    after do
      Object.send(:remove_const, :TestUser)
    end

    context 'when only #username is defined' do
      before do
        TestUser.stubs(:column_names).returns(['username'])
        TestUser.instance_eval { include(EasyAuth::Models::Account) }
      end

      it 'relies upon #username' do
        TestUser.identity_username_attribute.should eq :username
      end
    end

    context 'when only #email is defined' do
      before do
        TestUser.stubs(:column_names).returns(['email'])
        TestUser.instance_eval { include(EasyAuth::Models::Account) }
      end

      it 'relies upon #username' do
        TestUser.identity_username_attribute.should eq :email
      end
    end

    context 'when both #username and #email are defined' do
      before do
        TestUser.stubs(:column_names).returns(['email', 'username'])
        TestUser.instance_eval { include(EasyAuth::Models::Account) }
      end

      it 'prefers #username over #email' do
        TestUser.identity_username_attribute.should eq :username
      end
    end

    context 'when both #username and #email are not defined' do
      before do
        TestUser.stubs(:column_names).returns([])
      end

      it 'raises an Exception as no appropriate identity username attribute is available' do
        lambda {
          TestUser.send(:include, EasyAuth::Models::Account)
          TestUser.identity_username_attribute
        }.should raise_exception(EasyAuth::Models::Account::NoIdentityUsernameError)
      end
    end

    context 'when .identity_username_attribute is overridden' do
      before do
        TestUser.stubs(:identity_username_attribute).returns(:name)
        TestUser.send(:include, EasyAuth::Models::Account)
      end

      it 'returns :name' do
        TestUser.identity_username_attribute.should eq :name
      end
    end
  end
end
