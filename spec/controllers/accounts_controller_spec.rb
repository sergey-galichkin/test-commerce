require 'rails_helper'

RSpec.shared_examples "when account could not be created" do
  let!(:acc_count) { Account.count }

  it { is_expected.to have_http_status(:ok) }

  it { is_expected.to render_template(:new) }

  it "didn't create Account" do
   expect(Account.count).to eq acc_count
  end

  it "didn't create User" do
    expect(User.count).to be_zero
  end

  it "resets tenant" do
    expect(Apartment::Tenant.current).to eq('public')
  end

end

RSpec.shared_examples "when login parameters are invalid" do

  it { is_expected.to have_http_status(:redirect) }

  it { is_expected.to redirect_to(new_account_url subdomain: false) }

  it "resets tenant" do
    expect(Apartment::Tenant.current).to eq('public')
  end
end

RSpec.describe AccountsController, type: :controller do
  let(:params) { { name: 'testaccount', subdomain: subdomain, email: email, password: '12345678' } } 
  let(:subdomain) { 'testdomain' }
  let(:email) { 'admin@mail.com' }
  subject { response }

  describe "GET #new" do
    before(:each) { get :new }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template(:new) }
  end

  context "when AccountOwner role does not exist" do
    describe "POST #create" do
      before(:each) { post :create, account: params }
      it_behaves_like "when account could not be created"
    end
  end

  context "when AccountOwner role exists" do
    before(:each) { create(:account_owner) }

    context "when subdomain already exists" do
      before(:each) { create(:account, subdomain: subdomain) }

      describe "POST #create" do
        before(:each) { post :create, account: params }

        it_behaves_like "when account could not be created"
      end
    end

    describe "POST #create" do
      let(:account_params) { params }
      before(:each) { post :create, account: account_params }

      [:name, :subdomain, :email, :password].each do |param|
        context "when #{param} missing" do
          let(:account_params) { params.reject { |key, value| key == param } }
          it_behaves_like "when account could not be created"
        end
      end

      context "when successful" do

        it "creates Account" do
          expect(Account).to be_exist subdomain: subdomain
        end

        it "creates User" do
          expect(User).to be_exist email: email
        end

        it "switches tenant" do
          expect(Apartment::Tenant.current).to eq(subdomain)
        end

        it { is_expected.to have_http_status(:redirect) }

        it do
          params = { email: email, token: Account.last.registration_token }
          is_expected.to redirect_to(accounts_login_with_token_url subdomain: subdomain, params: params)
        end
      end
    end
  end

  describe "GET #login_with_token" do
    let(:params) { { email: create(:user).email, token: account.registration_token } }
    let(:account) { create :account }
    before(:each) { Apartment::Tenant.switch! account.subdomain }

    context "when invalid params" do
      before(:each) { get :login_with_token, wrong_params }

      [:email, :token].each do |param|
        context "when #{param} wrong" do
          let(:wrong_params) { params.merge({ param => "wrong" }) }
          it_behaves_like "when login parameters are invalid"
        end

        context "when #{param} missing" do
          let(:wrong_params) { params.reject { |key, value| key == param } }
          it_behaves_like "when login parameters are invalid"
        end
      end
    end

    context "when successfull" do
      before(:each) { get :login_with_token, params }

      it "resets registration_token" do
        expect(account.reload.registration_token).to be_nil
      end

      it "logins user" do
        expect(controller).to be_user_signed_in
      end

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:account_created) }

    end
  end
end
