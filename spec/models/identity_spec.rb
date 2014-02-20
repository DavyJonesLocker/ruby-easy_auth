require 'spec_helper'

describe EasyAuth::Models::Identity do
  describe 'uid' do
    subject { Identity.new }

    before do
      Identity.create(:uid => 'testuser', token: 'test')
      TestIdentity.create(:uid => 'otheruser', token: 'test')
    end

    it { should     have_valid(:uid).when('otheruser') }
    it { should_not have_valid(:uid).when(nil, '', 'testuser') }

    it { should     have_valid(:token).when('test') }
    it { should_not have_valid(:token).when(nil, '') }
  end
end
