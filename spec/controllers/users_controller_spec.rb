require 'rails_helper'

RSpec.shared_examples "when user could not be created" do

  it { is_expected.to have_http_status(:ok) }

  it { is_expected.to render_template(:new) }

  it "didn't create User" do
    expect(User.count).to eq(user_count)
  end
end

RSpec.describe UsersController, type: :controller do
  # TODO: move to shared context
  let(:account) { create :account }
  let (:account_owner) { create(:account_owner_user) }
  before(:each) do
    Apartment::Tenant.switch! account.subdomain
    sign_in account_owner
  end

  describe "when user not logged in" do
    before(:each) { sign_out account_owner }
    subject { response }

    {index: :get, new: :get, create: :post}.each do |action, method|
      describe "#{method}##{action}" do
        before(:each) { send(method, action) }

        it { is_expected.to have_http_status(:found) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end

  describe "when user logged in" do
    subject { response }

    [:index, :new].each do |action|
      describe "GET##{action}" do
        before(:each) { get action }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(action) }
      end
    end

    describe "POST#create" do
      let(:email) { 'user@mail.com' }
      let(:role) { Role.last }
      let(:params) { { email: email, password: '12345678', role_id: role.id } }
      let!(:user_count) { User.count }
      before(:each) { post :create, user: user_params }
      
      context "when invalid params" do
        [:email, :password, :role_id].each do |param|
          context "when #{param} missing" do
            let(:user_params) { params.reject { |key, value| key == param } }
            it_behaves_like "when user could not be created"
          end

          context "when #{param} wrong" do
            let(:user_params) { params.merge({ param => "wrong" }) }
            it_behaves_like "when user could not be created"
          end
        end
      end

      context "when successfull" do
        let(:user_params) { params }
        it "creates User" do
          expect(User).to be_exist email: email
        end
        it "User.count increased by 1" do
          expect(User.count).to eq(user_count + 1)
        end
      end
    end
  end
end
