require 'spec_helper'

describe EasyAuth::Models::Identity do
  describe 'username' do
    subject { Identity.new }
    before do
      Identity.create(:username => 'testuser')
      TestIdentity.create(:username => 'otheruser')
    end
    it { should     have_valid(:username).when('otheruser') }
    it { should_not have_valid(:username).when(nil, '', 'testuser') }
  end
end
