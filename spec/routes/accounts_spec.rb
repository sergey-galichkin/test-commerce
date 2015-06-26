require "rails_helper"

RSpec.shared_examples "should route" do
  it { is_expected.to route_to route }
end

RSpec.shared_examples "should not route" do
  it { is_expected.to_not route_to route }
end

RSpec.describe "routes for Accounts", type: :routing do
  let(:host) { 'test.host' }
  let(:subdomain) { 'testdomain' }

  context "when get new_account_path" do
    let(:route) { 'accounts#new' }
    subject { get new_account_url host: host, subdomain: subdomain }

    context "when subdomain missing" do
      let(:subdomain) { '' }
      it_behaves_like "should route"
    end

    context "when subdomain present" do
      it_behaves_like "should not route"
    end
  end

  context "when post accounts_path" do
    let(:route) { 'accounts#create' }
    subject { post accounts_url host: host, subdomain: subdomain}

    context "when subdomain missing" do
      let(:subdomain) { '' }
      it_behaves_like "should route"
    end

    context "when subdomain present" do
      it_behaves_like "should not route"
    end
  end

  context "when get accounts_new_login_with_token_path " do
    let(:route) { 'accounts#login_with_token' }
    subject { get accounts_login_with_token_url host: host, subdomain: subdomain }

    context "when subdomain missing" do
      let(:subdomain) { '' }
      it_behaves_like "should not route"
    end

    context "when subdomain present" do
      it_behaves_like "should route"
    end
  end
end
