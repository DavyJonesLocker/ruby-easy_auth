require 'spec_helper'

describe EasyAuth::Models::Identities::OAuth1::Base do
  context 'access tokens' do
    before do
      class TestIdentity < EasyAuth::Identity
        include(EasyAuth::Models::Identities::OAuth1::Base)
      end
      TestIdentity.stubs(:client).returns(client)
    end
    let(:client)   { OAuth::Consumer.new('client_id', 'secret', :site => 'http://example.com', :authorize_url => '/auth', :token_url => '/token' ) }
    let(:identity) { TestIdentity.new :token => { :token => 'token', :secret => 'token-secret' } }

    describe '.get_access_token' do
      it 'returns an OAuth::AccessToken' do
        access_token = TestIdentity.get_access_token identity
        access_token.class.should eq OAuth::AccessToken
      end

      it 'sets the token\'s consumer to the class\'s client' do
        access_token = TestIdentity.get_access_token identity
        access_token.consumer.should eq client
      end

      it 'sets the token\'s token to the token passed in' do
        access_token = TestIdentity.get_access_token identity
        access_token.token.should eq 'token'
      end

      it 'sets the token\'s secret to the secret passed in' do
        access_token = TestIdentity.get_access_token identity
        access_token.secret.should eq 'token-secret'
      end
    end

    describe '#get_access_token' do
      it 'returns an OAuth::AccessToken' do
        access_token = identity.get_access_token
        access_token.class.should eq OAuth::AccessToken
      end

      it 'sets the token\'s consumer to the class\'s client' do
        access_token = identity.get_access_token
        access_token.consumer.should eq client
      end

      it 'sets the token\'s token to the token passed in' do
        access_token = identity.get_access_token
        access_token.token.should eq 'token'
      end

      it 'sets the token\'s secret to the secret passed in' do
        access_token = identity.get_access_token
        access_token.secret.should eq 'token-secret'
      end
    end
  end
end
