require 'rails_helper'

RSpec.shared_examples "when create parameters are invalid" do
  it { is_expected.to have_http_status(:ok) }

  it { is_expected.to render_template(:new) }
end

RSpec.shared_examples "when login parameters are invalid" do
  before(:each) do
    Account.create(subdomain:'testdomain', name: 'testaccount', registration_token: SecureRandom.uuid)
    Apartment::Tenant.create 'testdomain'
    Apartment::Tenant.switch! 'testdomain'
    User.create(email: 'admin@mail.com', password: '12345678')
  end
  after(:each) { Apartment::Tenant.drop('testdomain') rescue nil }

  subject { request }

  it { is_expected.to have_http_status(:redirect) }

  it { is_expected.to redirect_to(new_account_url subdomain: false) }

  it "resets tenant" do
    request
    expect(Apartment::Tenant.current).to eq('public')
  end
end

RSpec.describe AccountsController, type: :controller do

  describe "GET #new" do
    subject { get :new }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template(:new) }
  end

  describe "POST #create" do
    let(:request) { post :create, account: { name: 'testaccount',
                                             subdomain: 'testdomain',
                                             email: 'admin@mail.com',
                                             password: '12345678' } }
    subject { request }

    context "when subdomain already exists" do

      before(:each) { Account.create(subdomain:'testdomain', name: 'testaccount') }

      it_behaves_like "when create parameters are invalid"
    end

    context "when AccountOwner role does not exist" do

      it_behaves_like "when create parameters are invalid"

    end

    context "when successful" do
      before(:each) { Role.create(name: 'AccountOwner') }
      after(:each) { Apartment::Tenant.drop('testdomain') rescue nil }

      it "creates Account" do
        request
        expect(Account.find_by subdomain: 'testdomain').to be
      end

      it "creates User" do
        request
        expect(User.find_by email: 'admin@mail.com').to be
      end

      it "switches tenant" do
        request
        expect(Apartment::Tenant.current).to eq('testdomain')
      end

      it { is_expected.to have_http_status(:redirect) }

      it { is_expected.to redirect_to(
            login_with_token_new_account_url subdomain: 'testdomain',
               params: { email: 'admin@mail.com',
                        token: Account.find_by(name: 'testaccount').registration_token })
      }
    end
  end

  describe "GET #login_with_token" do
    context "when email in params is missing" do
      it_behaves_like "when login parameters are invalid" do
        let(:request) { get :login_with_token, token: '123' }
      end
    end

    context "when token in params is missing" do
      it_behaves_like "when login parameters are invalid" do
        let(:request) { get :login_with_token, email: 'admin@mail.com' }
      end
    end

    context "when email in params is wrong" do
      it_behaves_like "when login parameters are invalid" do
        let(:request) { get :login_with_token, email: 'wrong@mail.com',
                        token: Account.find_by(name: 'testaccount').registration_token }
      end
    end

    context "when token in params is wrong" do
      it_behaves_like "when login parameters are invalid" do
        let(:request) { get :login_with_token, email: 'admin@mail.com', token: 'wrong_token' }
      end
    end

    context "when successfull" do
      before(:each) do
        Account.create(subdomain:'testdomain', name: 'testaccount', registration_token: SecureRandom.uuid)
        Apartment::Tenant.create 'testdomain'
        Apartment::Tenant.switch! 'testdomain'
        User.create(email: 'admin@mail.com', password: '12345678')
      end
      after(:each) { Apartment::Tenant.drop('testdomain') rescue nil }
      let(:request) { get :login_with_token, email: 'admin@mail.com',
                      token: Account.find_by(name: 'testaccount').registration_token }

      subject { request }

      it "resets registration_token" do
        request
        expect(Account.find_by(name: 'testaccount').registration_token).to be_nil
      end

      it "logins user" do
        request
        expect(controller).to be_user_signed_in
      end

      it { is_expected.to have_http_status(:redirect) }

      it { is_expected.to redirect_to(:root) }

    end
  end
end
