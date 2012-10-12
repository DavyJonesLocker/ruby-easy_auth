require 'spec_helper'

feature 'Google OAuth Authentication', :js do
  use_vcr_cassette 'google_oauth', :match_requests_on => [:uri]

  scenario 'Google link redirects to the Google OAuth url' do
    visit sign_in_path

    click_link 'Google'
    current_url.should match /^https:\/\/accounts.google.com\//
  end

  scenario 'Handling a google callback' do
    visit oauth_callback_path(:provider => :google, :code => 'test-auth-code')

    current_path.should eq dashboard_path
    page.should have_content '123456789'
  end
end

feature 'Facebook OAuth Authentication', :js do
  use_vcr_cassette 'facebook_oauth', :match_requests_on => [:uri]

  scenario 'Facebook link redirects to the Facebook OAuth url' do
    visit sign_in_path

    click_link 'Facebook'
    current_url.should match /^https:\/\/www.facebook.com\/dialog/
  end

  scenario 'Handling a Facebook callback' do
    visit oauth_callback_path(:provider => :facebook, :code => 'test-auth-code')

    current_path.should eq dashboard_path
    page.should have_content '123456789'
  end
end

feature 'Github OAuth Authentication', :js do
  use_vcr_cassette 'github_oauth', :match_requests_on => [:uri], :decode_compressed_response => true

  scenario 'Github link redirects to the Github OAuth url' do
    visit sign_in_path

    click_link 'Github'
    current_url.should match /^https:\/\/github.com\/login/
  end

  scenario 'Handling a Github callback' do
    visit oauth_callback_path(:provider => :github, :code => 'test-auth-code')

    current_path.should eq dashboard_path
    page.should have_content '123456789'
  end
end
