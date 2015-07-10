
Given(/^user logged out$/) do
  visit destroy_user_session_path
end

Given(/^registered user opens "(.*?)" page$/) do |arg1|
  visit arg1
end

Then(/^page contains "(.*?)" link$/) do |arg1|
  expect(page).to have_link(arg1)
end

Then(/^page does not contain "(.*?)" link$/) do |arg1|
  expect(page).to_not have_link(arg1)
end

Given(/^enters correct email and password$/) do
  fill_account_owner_email_and_password
end

Given(/^enters incorrect email and password$/) do
  fill_in('Email', with: 'wrong@mail.com')
  fill_in('Password', with: 'wrong')
end

Given(/^registered user logs in$/) do
  visit new_user_session_path
  fill_account_owner_email_and_password
  click_button("Log in")
end

Then(/^change password page contains all fields$/) do
  expect(page).to have_field('Password', type: 'password')
  expect(page).to have_field('Confirm password', type: 'password')
  expect(page).to have_button('Update')
end

When(/^user enters new password$/) do
  fill_in('Password', with: '87654321')
end
