require 'rails_helper'

RSpec.shared_examples "when user could not be created or updated" do

  it { is_expected.to have_http_status(:ok) }

  it { is_expected.to render_template(template) }

  it "didn't change User.count" do
    expect(User.count).to eq(user_count)
  end
end

RSpec.shared_examples "when logged in user updates password" do
  it "updates User password" do
    expect(User.find(id).encrypted_password).not_to eq(origin_password)
  end

  it "re-sign-ins user" do
    expect(controller).to have_received(:sign_in).with(signed_user, bypass: true)
  end

  it "User.count not changed" do
    expect(User.count).to eq(user_count)
  end

  it { is_expected.to redirect_to(users_path) }
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
    let(:params) { {} }

    { index: :get, new: :get, create: :post, edit: :get, update: :put, destroy: :delete, \
      edit_password: :get , update_password: :patch }.each do |action, method|

      describe "#{method}##{action}" do
        let(:params) { {id: account_owner.id} } if [:edit, :update, :destroy].include? action
        before(:each) { send(method, action, params) }

        it { is_expected.to have_http_status(:found) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end

  describe "when user logged in" do
    let!(:user_count) { User.count }
    let(:params) { {} }
    subject { response }

    %w{index new edit edit_password}.each do |action|
      describe "GET##{action}" do
        let(:params) { {id: account_owner.id} } if ['edit', 'edit_password'].include? action
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
      before(:each) { request.env["HTTP_REFERER"] = users_path }

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

      context "when AccountOwner" do
        context "when successful" do
          let!(:origin_password) {account_owner.encrypted_password}
          let(:user_params) { params }
          let(:signed_user) { account_owner }
          before(:each) do
            allow(controller).to receive(:sign_in)
            put :update, id: user_id, user: user_params
          end

          it_behaves_like "when logged in user updates password"
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

      context "when User" do
        let(:some_user) { create :user}
        let!(:origin_password) {some_user.encrypted_password}
        let!(:user_count) { User.count }
        let(:id) { some_user.id }
        before(:each) do
          sign_out account_owner
          account_owner.destroy
          sign_in some_user
          allow(controller).to receive(:sign_in)
          put :update, id: id, user: user_params
        end
        context "when successful" do
          let(:user_params) { params.reject { |key, value| key == :role_id } }
          let(:signed_user) { some_user }

          it_behaves_like "when logged in user updates password"
        end

        context "when password is blank" do
          let(:user_params) { { password: ''} }

          it_behaves_like "when user could not be created or updated"
        end
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

    describe "PATCH#update_password" do
      let(:params) { { password: '87654321' } }
      before(:each) do
        allow(controller).to receive(:sign_in)
        patch :update_password, user: passw_params
      end

      context "when invalid params" do
        let(:template) { :edit_password }
        context "when password missing" do
          let(:passw_params) { params.reject { |key, value| key == :password } }
          it_behaves_like "when user could not be created or updated"
        end
        context "when password wrong" do
          let(:passw_params) { params.merge({ password: "wrong" }) }
          it_behaves_like "when user could not be created or updated"
        end
      end

      context "when successful" do
        let!(:origin_password) {account_owner.encrypted_password}
        let(:passw_params) { params }

        it "updates User password" do
          expect(account_owner.reload.encrypted_password).not_to eq(origin_password)
        end

        it "re-sign-ins user" do
          expect(controller).to have_received(:sign_in).with(account_owner, bypass: true)
        end

        it "User.count not changed" do
          expect(User.count).to eq(user_count)
        end
        it { is_expected.to redirect_to(root_path) }
      end
    end
  end
end
