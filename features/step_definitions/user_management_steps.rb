#admin_mail = 'test@mail.com'

Given(/^all accounts are cleaned$/) do
  cleanup_database
  create_roles
end

And(/^User registers account$/) do
  register_account
end

Given(/^AccountOwner visits user management page$/) do
  visit users_path
end

Given(/^User with "(.*?)" permission visits user management page$/) do |arg1|
  create_user_with_permission arg1

  login_new_user

  visit users_path
end

Then(/^user management page contains all fields$/) do
  expect(page).to have_link('Create New', href: new_user_path)
  expect(page).to have_table ''
  expect(page).to have_selector 'table tr', count: 2
  expect(all('tr th')[0]).to have_text 'Email'
  expect(all('tr th')[1]).to have_text 'Role'
  expect(all('tr th')[2]).to have_text 'Actions'

  expect(all('tr td')[0]).to have_text 'test@mail.com'
  expect(all('tr td')[1]).to have_text 'AccountOwner'
  expect(all('tr td')[2]).to have_link('Edit', href: edit_user_path(1))
  expect(all('tr td')[2]).to have_link('Delete', href: user_path(1))
end

Then(/^create new user form contains all fields$/) do
  expect(page).to have_field('Email', type: 'email')
  expect(page).to have_select('user[role_id]')
  expect(page).to have_field('Password', type: 'password')
  expect(page).to have_field('Confirm password', type: 'password')
  expect(page).to have_button('Create')
end

Given(/^AccountOwner opens new user page$/) do
  visit new_user_path
end

When(/^AccountOwner properly fills the form$/) do
  fill_new_user_form
end

Then(/^edit user form contains all fields$/) do
  expect(find_field('Email', disabled: true, with: 'test@mail.com')).to be
  expect(page).to have_select('user[role_id]')
  expect(page).to have_field('Password', type: 'password')
  expect(page).to have_field('Confirm password', type: 'password')
  expect(page).to have_button('Update User')
end

Then(/^user management page shows new user$/) do
  expect(all('tr td')[3]).to have_text 'user@mail.com'
  expect(all('tr td')[4]).to have_text 'User'
  expect(all('tr td')[5]).to have_link('Edit', href: edit_user_path(2))
  expect(all('tr td')[5]).to have_link('Delete', href: user_path(2))
end

Given(/^creates new user with role "(.*?)"$/) do |arg1|
  visit new_user_path
  fill_new_user_form arg1
  click_button('Create User')
end

When(/^user clicks "(.*?)" link on created user$/) do |arg1|
  all('tr td')[5].click_link(arg1)
end

Then(/^user updates role$/) do
  select 'AccountOwner', from: 'user[role_id]'
end

Then(/^user updates password$/) do
  fill_in('Password', with: '87654321')
  fill_in('Confirm password', with: '87654321')
end

Then(/^user management page shows updated user role$/) do
  expect(all('tr td')[4]).to have_text 'AccountOwner'
end

Then(/^user management page does not shows deleted user$/) do
  expect(all('tr td').count).to eq 3
  expect(page).to_not have_content 'user@mail.com'
end

Then(/^user management page shows user$/) do
  expect(all('tr td')[0]).to have_text 'test@mail.com'
  expect(all('tr td')[1]).to have_text 'AccountOwner'
end

def fill_account_owner_email_and_password
  fill_in('Email', with: 'test@mail.com')
  fill_in('Password', with: '12345678')
end

private

def fill_and_submit_register_account_form
  fill_in('Name', with: 'Test Account')
  fill_in('Subdomain', with: 'testsubdomain')
  fill_account_owner_email_and_password
  fill_in('Confirm password', with: '12345678')
  click_button('Create Account')
end

def fill_new_user_form role= 'User', email= 'user@mail.com', password= '12345678'
  fill_in('Email', with: email)
  select role, from: 'user[role_id]'
  fill_in('Password', with: password)
  fill_in('Confirm password', with: '12345678')
end

def fill_login_form email= 'user@mail.com', password= '12345678'
  fill_in('Email', with: email)
  fill_in('Password', with: password)
end

def cleanup_database
  Account.destroy_all
  Apartment::Tenant.drop 'testsubdomain' rescue nil
  Apartment::Tenant.reset
  DatabaseCleaner.clean
end

def create_roles
  FactoryGirl.create(:account_owner_role)
  FactoryGirl.create(:user_role)
end

def register_account
  Capybara.default_host = "http://lvh.me:3000"
  visit new_account_path
  fill_and_submit_register_account_form
  Capybara.default_host = "http://testsubdomain.lvh.me:3000"

def create_user_with_permission permission
  permission = "User" if permission == "cannot manage users"
  step "AccountOwner visits user management page"
  step "creates new user with role \"#{permission}\""
end

def login_new_user
  step "user logged out"
  visit new_user_session_path
  fill_login_form
  click_button("Log in")
end

end
