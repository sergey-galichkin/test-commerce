require "rails_helper"

RSpec.feature "account_management.start_page", :type => :feature do
  scenario "User visits start page" do
    visit_url "localhost:8080"
    expect(page).to have_link("Registration")
  end
end