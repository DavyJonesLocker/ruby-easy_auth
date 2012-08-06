require 'spec_helper'

feature 'Password reset' do
  before do
    clear_emails
  end

  scenario 'when the identity exists' do
    user = create(:user)
    visit password_reset_path
    fill_in 'Username', :with => user.email
    click_button 'Submit'
    open_email(user.email)
    current_email.click_link 'password'
    fill_in 'Password', :with => 'new_password'
    fill_in 'Password confirmation', :with => 'new_password'
    click_button 'Submit'
    page.should have_content 'test@example.com'
    visit sign_out_path
    visit sign_in_path
    fill_in 'Username', :with => user.email
    fill_in 'Password', :with => 'new_password'
    click_button 'Submit'
    page.should have_content 'test@example.com'
  end

  scenario 'failed password reset' do
    user = create(:user)
    visit password_reset_path
    fill_in 'Username', :with => user.email
    click_button 'Submit'
    open_email(user.email)
    current_email.click_link 'password'
    click_button 'Submit'
    page.should have_content 'There was an issue updating your password.'
  end
end
