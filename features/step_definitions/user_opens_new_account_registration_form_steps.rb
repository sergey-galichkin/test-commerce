Given(/^user visits start page$/) do
  visit root_path
end

When(/^user clicks "(.*?)" link$/) do |arg1|
  click_link(arg1)
end

Then(/^user is redirected to "(.*?)" page$/) do |arg1|
  expect(current_path).to eql(new_account_path) # TODO how to use arg1 here?
end

Then(/^registration page contains all fields$/) do
  expect(page).to have_field('Name', type: 'text')

  expect(page).to have_field('Subdomain', type: 'text')

  expect(page).to have_field('Email', type: 'email')

  expect(page).to have_field('Password', type: 'password')

  expect(page).to have_field('Confirm password', type: 'password')

  expect(page).to have_selector(:button, 'Create Account')
end
