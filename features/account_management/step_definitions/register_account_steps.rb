
Given(/^user visits start page$/) do
  visit '/'
end

When(/^user clicks "(.*?)" link$/) do |arg1|
  click_link(arg1)
end

Then(/^user is redirected to "(.*?)" page$/) do |arg1|
  expect(current_path).to eql(new_account_path) # TODO how to use arg1 here?
end

Then(/^registration page contains all fields$/) do
#  subject {page}
#  it { is_expected.to have_field('subdomain') }
#  it "has subdomain" do

  expect(page).to have_field('name')
  expect(page).to have_content('name')

  expect(page).to have_field('subdomain')
  expect(page).to have_content('subdomain')

  expect(page).to have_field('email')
  expect(page).to have_content('email')

  expect(page).to have_field('password')
  expect(page).to have_content('password')

  expect(page).to have_field('confirm_password')
  expect(page).to have_content('confirm_password')

  expect(page).to  have_selector(:link_or_button, 'Create')

end
