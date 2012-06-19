require 'spec_helper'

describe EasyAuth::Models::Account do
  context '.identity_username_attribute' do
    before do
      class TestUser; end
      TestUser.stubs(:has_one)
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
          TestUser.instance_eval { include(EasyAuth::Models::Account) }
        }.should raise_exception(EasyAuth::Models::Account::NoIdentityUsernameError)
      end
    end
  end

  context 'when idetnity validations are skipped' do
    it 'does not create an identity or validate the attributes' do
      user = User.create(:skip_identity_validations => true)
      user.identity.should be_nil
      user.id.should_not be_nil
    end
  end

  describe '#generate_session_token!' do
    it 'sets a unique session token' do
      user = create(:user, :skip_identity_validations => true)
      user.session_token.should be_nil
      user.generate_session_token!
      user = User.last
      user.session_token.should_not be_nil
    end
  end
end
