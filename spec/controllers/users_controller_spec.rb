require 'rails_helper'

RSpec.shared_examples "when user could not be created or updated" do

  it { is_expected.to have_http_status(:ok) }

  it { is_expected.to render_template(template) }

  it "didn't change User.count" do
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

    { index: :get, new: :get, create: :post, edit: :get, update: :put, destroy: :delete }.each do |action, method|
      describe "#{method}##{action}" do
        let(:param) { {id: account_owner.id} }
        before(:each) do
          if [:edit, :update, :destroy].include? action
            send(method, action, param)
          else
            send(method, action)
          end
        end

        it { is_expected.to have_http_status(:found) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end

  describe "when user logged in" do
    let!(:user_count) { User.count }
    let(:params) { {} }
    subject { response }

    %w{index new edit}.each do |action|
      describe "GET##{action}" do
        let(:params) { {id: account_owner.id} } if action == 'edit'
        before(:each) { get action, params }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(action) }

        it { expect { controller }.not_to raise_error() }

      end
    end

    describe "POST#create" do
      let(:email) { 'user@mail.com' }
      let(:role) { Role.last }
      let(:params) { { email: email, password: '12345678', role_id: role.id } }
      let(:template) { :new }
      before(:each) { post :create, user: user_params }
      
      context "when invalid params" do
        [:email, :password, :role_id].each do |param|
          context "when #{param} missing" do
            let(:user_params) { params.reject { |key, value| key == param } }
            it_behaves_like "when user could not be created or updated"
          end

          context "when #{param} wrong" do
            let(:user_params) { params.merge({ param => "wrong" }) }
            it_behaves_like "when user could not be created or updated"
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
        it { is_expected.to redirect_to(users_path) }
      end
    end

    describe "PUT#update" do
      let(:role) { create(:role) }
      let(:params) { {password: '12345678', role_id: role.id} }
      let(:template) { :edit }
      let(:id) { account_owner.id }
      let(:user_id) { id }

      context "when id wrong" do
        let(:user_params) { params }
        let(:user_id) { id+100 }
        subject { put :update, id: user_id, user: user_params }
        it {expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
      end

      [:password, :role_id].each do |param|
        context "when #{param} wrong" do
          before(:each) { put :update, id: user_id, user: user_params }
          let(:user_params) { params.merge({ param => "wrong" }) }
          it_behaves_like "when user could not be created or updated"
        end
      end

      context "when successful" do
        let!(:origin_password) {account_owner.encrypted_password}
        let(:user_params) { params }
        before(:each) { put :update, id: user_id, user: user_params }
        it "updates User role" do
          expect(User.find(id).role).to eq role
        end
        it "updates User password" do
          expect(User.find(id).encrypted_password).not_to eq(origin_password)
        end
        it "User.count not changed" do
          expect(User.count).to eq(user_count)
        end
        it { is_expected.to redirect_to(users_path) }
      end

      context "when password is blank" do
        let!(:origin_password) {account_owner.encrypted_password}
        let(:user_params) { params.merge({ password: ''}) }
        before(:each) { put :update, id: user_id, user: user_params }
        it "updates User role" do
          expect(account_owner.reload.role_id).to eq(role.id)
        end
        it "does not update User password" do
          expect(account_owner.reload.encrypted_password).to eq(origin_password)
        end
        it "User.count not changed" do
          expect(User.count).to eq(user_count)
        end
        it { is_expected.to redirect_to(users_path) }
      end
    end

    describe "DELETE#destroy" do
      let(:some_user) { create(:user) }
      let(:id) { some_user.id }
      let(:user_id) { id }
      context "when id wrong" do
        let(:user_id) { id+100 }
        subject { delete :destroy, id: user_id }
        it {expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
      end
      context "when successful" do
        before(:each) { delete :destroy, id: user_id }

        it "deletes user" do
          expect{some_user.reload}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "User.count decreased by 1" do
          expect(User.count).to eq(1)
        end

        it { is_expected.to redirect_to(users_path) }
      end

      context "when try to delete logged in user" do
        let(:user_id) { account_owner.id }
        before(:each) { delete :destroy, id: user_id }

        it "does not delete user" do
          expect(account_owner.reload).to be(account_owner)
        end

        it "User.count not changed" do
          expect(User.count).to eq(user_count)
        end

        it { is_expected.to redirect_to(users_path) }
      end
    end
  end
end
