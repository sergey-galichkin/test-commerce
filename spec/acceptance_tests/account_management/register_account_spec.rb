require "rails_helper"

RSpec.feature "account_management.register_account", :type => :feature do
  background do
    # cleanup_database
    create_roles
    visit_url "lvh.me:3000"
  end

  context 'User visits account registration page' do
    before(:each) do
      click_link strings(:registration)
    end

    # scenario "user opens new account registration form" do
    #   expect_page_url_to_be 'lvh.me:3000/accounts/new'
    #   expect(page).to have_field(strings(:name), type: 'text')
    #   expect(page).to have_field(strings(:subdomain), type: 'text')
    #   expect(page).to have_field(strings(:login), type: 'email')
    #   expect(page).to have_field(strings(:password), type: 'password')
    #   expect(page).to have_field(strings(:pass_confirm), type: 'password')
    #   expect(page).to have_button(strings(:create_account_btn))
    # end

    scenario 'user registers new account' do
      # register_account('test1@mail.com', 'password', 'Tenant1', 'MySubdomain1')

  Capybara.default_host = "http://lvh.me:3000"
  visit new_account_path
  fill_in('Name', with: 'Test Account')
  fill_in('Subdomain', with: 'testsubdomain')
  fill_in('Email', with: 'test@mail.com')
  fill_in('Password', with: '12345678')
  fill_in('Confirm password', with: '12345678')
  click_button('Create Account')
  Capybara.default_host = "http://testsubdomain.lvh.me:3000"



      
    end
  end
end