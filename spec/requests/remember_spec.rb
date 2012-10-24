require 'spec_helper'

feature 'Remember Me' do
  scenario 'when the identity exists' do
    user = create(:user)
    Capybara.session_name = :browser_1
    visit sign_in_path
    fill_in 'Username', :with => 'test@example.com'
    fill_in 'Password', :with => 'password'
    check 'Remember for 1 year'
    click_button 'Submit'
    Capybara.session_name = :browser_2
    user.reload
    cookies['remember_token'] = user.identities.first.remember_token
    visit root_path
    current_path.should eq dashboard_path
  end

  scenario 'when the identity does not exist' do
    cookies['remember_token'] = 'junk'
    visit root_path
    current_path.should eq root_path
    cookies['remember_token'].should be_blank
  end

  scenario 'after sign out' do
    user = create(:user)
    Capybara.session_name = :browser_1
    visit sign_in_path
    fill_in 'Username', :with => 'test@example.com'
    fill_in 'Password', :with => 'password'
    check 'Remember for 1 year'
    click_button 'Submit'
    visit sign_out_path
    Capybara.session_name = :browser_2
    cookies['remember_token'] = user.identities.first.remember_token
    visit root_path
    current_path.should_not eq dashboard_path
  end
end
