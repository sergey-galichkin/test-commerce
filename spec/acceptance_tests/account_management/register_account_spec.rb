require "rails_helper"

RSpec.feature "account_management.register_account", :type => :feature do
  background do
    cleanup_database
    create_roles
    visit_url "lvh.me:3000"
  end

  context 'User visits account registration page' do
    before(:each) do
      click_link strings(:registration)
    end

    scenario "user opens new account registration form" do
      sleep(20)
      expect_page_url_to_be 'lvh.me:3000/accounts/new'
      expect(page).to have_field(strings(:name), type: 'text')
      expect(page).to have_field(strings(:subdomain), type: 'text')
      expect(page).to have_field(strings(:login), type: 'email')
      expect(page).to have_field(strings(:password), type: 'password')
      expect(page).to have_field(strings(:pass_confirm), type: 'password')
      expect(page).to have_button(strings(:create_account_btn))
    end

    scenario 'user registers new account' do
      register_account('test1@mail.com', 'password', 'Tenant1', 'MySubdomain1')
    end
  end
end