def sign_in_with(account)
  visit sign_in_path
  fill_in 'Username', :with => account.email
  fill_in 'Password', :with => account.password
  click_button 'Submit'

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
