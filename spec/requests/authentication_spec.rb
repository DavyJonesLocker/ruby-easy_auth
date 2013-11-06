require 'spec_helper'

feature 'Authentication' do
  scenario 'with valid attributes' do
    create(:user)
    visit sign_in_path
    click_button 'Sign in'
    current_path.should eq dashboard_path
    page.should have_content 'test@example.com'
  end

  scenario 'signing out' do
    create(:user)
    visit sign_out_path
    current_path.should eq root_path
  end
end

feature 'Unauthenticated' do
  scenario 'accessing a page that requires authentication when account is already created' do
    create(:user)
    visit profile_path
    click_button 'Sign in'
    page.should have_content 'My profile'
  end

  scenario 'accessing a page that requires authentication via ajax' do
    get profile_path(:format => :json)
    response.status.should eq 401
  end

  scenario 'redirects to request referer on successful sign in for non GET request' do
    create(:user)
    visit landings_path
    click_button 'Submit Authenticated Post'

    click_button 'Sign in'

    current_path.should eq landings_path
  end
end
