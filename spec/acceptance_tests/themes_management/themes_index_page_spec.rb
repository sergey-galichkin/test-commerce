require "rails_helper"
require './spec/acceptance_tests/common_methods.rb'
require './spec/acceptance_tests/strings.rb'

RSpec.shared_context "visit page with permission" do
  before(:each) do
    User.last.update role: create(role)
    visit_url url
  end
end

RSpec.feature "theme_management.start_page", :type => :feature do
  let(:subdomain) { "testsubdomain" }
  let(:host_url) { subdomain + ".lvh.me:3000" }
  let(:themes_url) { host_url + Strings.get[:themes_index_page] }
  let(:themes_new_url) { host_url + Strings.get[:themes_new_page] }
  let(:theme) { create(:theme) }

  include Common_methods

  background do
    cleanup_database
    register_account('test@mail.com', 'password', 'Test Tenant', subdomain)
    User.last.update role: create(:manage_themes_role)
  end

  context "User without themes permissions" do
    context "User without all themes permissions" do
      include_context "visit page with permission" do
       let(:role) { :role }
       let(:url) { themes_url }
     end
      scenario "gets auth.error when visits themes index page" do
        expect_page_url_to_be (host_url + "/")
        expect_error(Strings.get[:authorization_error])
      end
    end
    context "User without create themes permissions" do
      include_context "visit page with permission" do
        let(:role) { :delete_themes_role }
        let(:url) { themes_url }
      end
      scenario "cannot create new theme" do
        expect_page_url_to_be themes_url
        expect(page).to have_no_link(Strings.get[:create_theme_btn], href: new_theme_path)
      end
    end
    context "User without delete themes permissions" do
      before(:each) do
        theme
        User.last.update role: create(:create_themes_role)
        visit_url themes_url
      end
      scenario "cannot delete theme" do
        expect_page_url_to_be themes_url
        expect(all('tr td')[2]).to have_no_link(Strings.get[:delete], href: theme_path(1))
      end
    end
  end

  context "User with themes permissions" do
    let(:url) { host_url + Strings.get[:themes_create_completed] + param }
    before(:each) do
      theme
      visit_url themes_url
    end
    context  "User with all themes permissions visits themes index page" do
      scenario "and page contains all fields" do
        expect_page_url_to_be themes_url

        expect(page).to have_link(Strings.get[:create_theme_btn], href: new_theme_path)

        expect(page).to have_table ''
        expect(page).to have_selector 'table tr', count: 2
        expect(all('tr th')[0]).to have_text Strings.get[:name]
        expect(all('tr th')[1]).to have_text Strings.get[:status]
        expect(all('tr th')[2]).to have_text Strings.get[:actions]

        expect(all('tr td')[0]).to have_text theme.name
        expect(all('tr td')[1]).to have_text theme.status
        expect(all('tr td')[2]).to have_link(Strings.get[:delete], href: theme_path(1))
      end
    end
    context  "User clicks Create New link and opens Create Theme page" do
      scenario "and page contains all fields" do
        click_link(Strings.get[:create_theme_btn])
        expect_page_url_to_be themes_new_url
        expect(page).to have_field(Strings.get[:open_file_btn])
        expect(page).to have_button(Strings.get[:upload_file_btn])
      end
    end
    context  "clicks Create New link and selects theme zip file" do
      let(:param) { "?key=12345_test theme.zip" }
      scenario "clicks Upload Theme and successfully uploads new Theme" do
        click_link(Strings.get[:create_theme_btn])

        # click_button(Strings.get[:upload_file_btn])
        # Couldn't stub redirect from Amazon, just call action directly
        visit_url url

        expect_page_url_to_be themes_url
        expect_no_errors
        expect_notification Strings.get[:theme_created]
        expect(all('tr td')[3]).to have_text Theme.last.name
        expect(all('tr td')[4]).to have_text Theme.last.status
        expect(all('tr td')[5]).to have_link(Strings.get[:delete], href: theme_path(2))
      end
    end
    context  "clicks Create New link and does not select theme file" do
      let(:param) { "?key=12345_" }
      scenario "clicks Upload Theme and gets an error" do
        click_link(Strings.get[:create_theme_btn])

        visit_url url

        expect_page_url_to_be themes_new_url
        expect_no_notifications
        expect_error Strings.get[:theme_blank_name_error]
      end
    end
    context  "clicks Create New link and select theme file not in ZIP format" do
      let(:param) { "?key=12345_theme.exe" }
      scenario "clicks Upload Theme and gets an error" do
        click_link(Strings.get[:create_theme_btn])

        visit_url url

        expect_page_url_to_be themes_new_url
        expect_no_notifications
        expect_error Strings.get[:theme_file_ext_error]
      end
    end
    context  "User with all themes permissions visits themes index page" do
      scenario "clicks Delete link and successfully deletes theme" do
        click_link(Strings.get[:delete])

        expect_page_url_to_be themes_url
        expect(page).to have_selector 'table tr', count: 1
        expect_no_errors
        expect_notification Strings.get[:theme_deleted]
      end
    end
  end
end
