require 'rails_helper'

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

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }

      it "sets flash message" do
        request
        expect(controller).to set_flash[:alert].to(/already registered/)
      end
    end

    context "when AccountOwner role does not exist" do

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }

      it "sets flash message" do
        request
        expect(controller).to set_flash[:alert].to(/exception has occured during account creation/)
      end
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
end
