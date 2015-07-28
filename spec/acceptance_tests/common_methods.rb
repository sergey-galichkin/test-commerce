module Common_methods
  def strings(str)
    Strings.get[str]
  end

  def visit_url(url)
    Capybara.visit "http://#{url}"
  end

  def expect_page_url_to_be(url)
    expect(current_url).to eq("http://#{url}")
  end

  def expect_error(message)
    expect(page.find('#errors')).to have_content(message)
  end

  def expect_no_errors
    expect(page.find('#errors').text).to eq ""
  end

  def expect_notification(message)
    expect(page.find('#notifications')).to have_content(message)
  end

  def expect_no_notifications
    expect(page.find('#notifications').text).to eq ""
  end

  def log_in_with(login, pass)
    fill_in('E-mail', with: login)
    fill_in('Password', with: pass)
    click_button "Log in"
  end

  def cleanup_database
    Account.destroy_all
#    Apartment::Tenant.drop 'MySubdomain1' rescue nil
    Apartment::Tenant.reset
    DatabaseCleaner.clean
  end

  def create_roles
    FactoryGirl.create(:account_owner_role)
    FactoryGirl.create(:user_role)
    FactoryGirl.create(:create_users_role)
    FactoryGirl.create(:update_users_role_role)
    FactoryGirl.create(:update_users_password_role)
    FactoryGirl.create(:update_users_role_and_password_role)
    FactoryGirl.create(:delete_users_role)
  end

  def register_account(login, password, name, subdomain)
    visit_url 'lvh.me:3000'
    click_link (strings(:registration))
    fill_in(strings(:login), with: login)
    fill_in(strings(:password), with: password)
    fill_in(strings(:pass_confirm), with: password)
    fill_in(strings(:name), with: name)
    fill_in(strings(:subdomain), with: subdomain)
    click_button(strings(:create_account_btn))
  end

end
