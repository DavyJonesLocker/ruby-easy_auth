require 'spec_helper'

describe EasyAuth::Models::Identities::OAuth2::Base do
  context 'access tokens' do
    before do
      class TestIdentity < EasyAuth::Identity
        include(EasyAuth::Models::Identities::OAuth2::Base)
      end
      TestIdentity.stubs(:client).returns(client)
    end

    let(:client)   { OAuth2::Client.new('client_id', 'secret', :site => 'http://example.com', :authorize_url => '/auth', :token_url => '/token' ) }
    let(:identity) { TestIdentity.new :token => 'token' }

    describe '.get_access_token' do
      it 'returns an OAuth2 Access Token' do
        access_token = TestIdentity.get_access_token identity
        access_token.class.should eq OAuth2::AccessToken
      end

      it "sets the token's client to the class's client" do
        access_token = TestIdentity.get_access_token identity
        access_token.client.should eq client
      end

      it "sets the token's token to the token passed in" do
        access_token = TestIdentity.get_access_token identity
        access_token.token.should eq 'token'
      end
    end

    describe '#get_access_token' do
      it 'returns an OAuth2 Access Token' do
        access_token = identity.get_access_token
        access_token.class.should eq OAuth2::AccessToken
      end

      it "sets the token's client to the class\'s client" do
        access_token = identity.get_access_token
        access_token.client.should eq client
      end

      it "sets the token's token to the token passed in" do
        access_token = identity.get_access_token
        access_token.token.should eq 'token'
      end

    end

    after do
      Object.send(:remove_const, :TestIdentity)
    end
  end
end
