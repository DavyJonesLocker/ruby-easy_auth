require 'spec_helper'

describe EasyAuth::Account do
  after do
    Object.send(:remove_const, :TestUser)
  end

  context '.identity_username_attribute' do
    before do
      class TestUser; end
      TestUser.stubs(:has_one)
      TestUser.stubs(:before_create)
      TestUser.stubs(:before_update)
      TestUser.stubs(:validates)
      TestUser.stubs(:attr_accessible)
    end


    context 'when only #username is defined' do
      before do
        TestUser.stubs(:column_names).returns(['username'])
        TestUser.instance_eval { include(EasyAuth::Account) }
      end

      it 'relies upon #username' do
        TestUser.identity_username_attribute.should eq :username
      end
    end

    context 'when only #email is defined' do
      before do
        TestUser.stubs(:column_names).returns(['email'])
        TestUser.instance_eval { include(EasyAuth::Account) }
      end

      it 'relies upon #username' do
        TestUser.identity_username_attribute.should eq :email
      end
    end

    context 'when both #username and #email are defined' do
      before do
        TestUser.stubs(:column_names).returns(['email', 'username'])
        TestUser.instance_eval { include(EasyAuth::Account) }
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
          TestUser.instance_eval { include(EasyAuth::Account) }
        }.should raise_exception(EasyAuth::Account::NoIdentityUsernameError)
      end
    end
  end
end