require 'spec_helper'

describe EasyAuth::Models::Identity do
  describe 'uid' do
    subject { Identity.new }
    before do
      Identity.create(uid: ['testuser'])
      TestIdentity.create(uid: ['otheruser'])
    end

    it { should     have_valid(:uid).when(['otheruser']) }
    it { should_not have_valid(:uid).when([], ['testuser']) }
  end
end
