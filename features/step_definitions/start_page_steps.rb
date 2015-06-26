Given(/^anonymous user$/) do
end

When(/^user opens start page$/) do
  visit '/'
end

Then(/^user should see link to new account registration page$/) do
  expect(page).to have_link 'Registration', href: '/accounts/new'
end
