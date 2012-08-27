require 'spec_helper'

feature 'Authentication' do
  scenario 'with valid attributes' do
    create(:user)
    visit sign_in_path
    fill_in 'Username', :with => 'test@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Submit'

    current_path.should eq dashboard_path
    page.should have_content 'test@example.com'
  end

  scenario 'with invalid attributes' do
    visit sign_in_path
    click_button 'Submit'

    current_path.should eq sign_in_path
  end

  scenario 'signing out' do
    sign_in_with(create(:user))

    visit sign_out_path
    current_path.should eq root_path
  end

  scenario 'updating the account should update the identity' do
    user = create(:user)
    user.update_attributes(:email => 'changed@example.com', :password => 'changed_password', :password_confirmation => 'changed_password')
    sign_in_with(user)
  end

  scenario 'partially updating the account should update the identity' do
    create(:user)
    # ensure we clear the attr accessors
    user = User.last
    user.update_attributes(:email => 'changed@example.com')
    user.password              = 'password'
    user.password_confirmation = 'password'
    sign_in_with(user)
  end

  scenario 'visiting sign in path' do
    sign_in_with(create(:user))
    visit sign_in_path
    current_path.should eq dashboard_path
  end
end

feature 'Unauthenticated' do
  scenario 'accessing a page that requires authentication when account is already created' do
    user = create(:user)

    visit profile_path

    fill_in 'Username', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Submit'

    page.should have_content 'My profile'
  end

  scenario 'accessing a page that requires authentication via ajax' do
    get profile_path(:format => :json)
    response.status.should eq 401
  end
end
