require "rails_helper"

RSpec.describe "routes for Accounts", type: :routing do
  context "when subdomain missing" do
    subject { get login_with_token_new_account_path }
    it { is_expected.to_not route_to 'accounts#login_with_token' }
  end

  context "when subdomain present" do
    subject { get login_with_token_new_account_url host: 'test.host', subdomain: "testdomain" }
    it { is_expected.to route_to 'accounts#login_with_token' }
  end
end
