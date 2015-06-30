
Given(/^all accounts are cleaned$/) do
  cleanup_database
end

And(/^User registers account$/) do
  register_account
end

Given(/^AccountOwner visits user management page$/) do
  visit users_path
end

Then(/^user management page contains all fields$/) do
  expect(page).to have_link('Create New', href: new_user_path)
  expect(page).to have_table ''
  expect(find('tr th', text: 'Email')).to have_content 'Email'
  expect(find('tr th', text: 'Role')).to have_content 'Role'
  expect(find('tr th', text: 'Actions')).to have_content 'Actions'
  expect(page).to have_selector 'table tr', count: 2
end

Then(/^create new user form contains all fields$/) do

  expect(page).to have_field('Email', type: 'email')

  expect(page).to have_field('Password', type: 'password')

  expect(page).to have_field('Confirm password', type: 'password')

  expect(page).to have_button('Create')
end

def fill_and_submit_register_account_form
  fill_in('Name', with: 'Test Account')
  fill_in('Subdomain', with: 'testsubdomain')
  fill_in('Email', with: 'test@mail.com')
  fill_in('Password', with: '12345678')
  fill_in('Confirm password', with: '12345678')
  click_button('Create Account')
end

def cleanup_database
  Account.destroy_all
  Apartment::Tenant.drop 'testsubdomain' rescue nil
  Apartment::Tenant.reset
  DatabaseCleaner.clean
end

def register_account
  FactoryGirl.create(:account_owner_role)
  Capybara.default_host = "http://lvh.me:3000"
  visit new_account_path
  fill_and_submit_register_account_form
  Capybara.default_host = "http://testsubdomain.lvh.me:3000"
end
