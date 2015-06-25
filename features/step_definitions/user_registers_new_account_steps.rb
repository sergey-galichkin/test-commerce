Given(/^user visits registration page$/) do
  FactoryGirl.create(:account_owner) # TODO :should it be in db/seed?
  visit new_account_path
end

When(/^user properly fills the form$/) do
  fill_in('Name', with: 'Test Account')
  fill_in('Subdomain', with: 'testsubdomain')
  fill_in('Email', with: 'test@mail.com')
  fill_in('Password', with: '12345678')
  fill_in('Confirm password', with: '12345678')
end

When(/^presses "(.*?)" button$/) do |arg1|
  click_button(arg1)
end
