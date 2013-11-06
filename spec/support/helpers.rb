def sign_in_with(account)
  visit sign_in_path
  click_button 'Sign in'

  current_path.should eq dashboard_path
  page.should have_content account.email
  self.current_account = account
end

def current_account=(account)
  @account = account
end

def current_account
  @account
end

def fill_in_authenticated_post
  fill_in 'Title', with: 'Example Title'
  fill_in 'Password', with: 'password'
  click_button 'Create Authenticated post'
end
