require 'rails_helper'
require "cancan/matchers"

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

RSpec.shared_context "when user have update password permission" do
  let(:user_params) { params }
  let!(:origin_password) {user_under_test.encrypted_password}
  let(:signed_user) { user_under_test }
  before(:each) do
    user_under_test.update role: create(update_users_role)
    @origin_role = user_under_test.role
    allow(controller).to receive(:sign_in)
    put :update, id: id, user: user_params
  end
end


RSpec.describe UsersController, type: :controller do
  # TODO: move to shared context
  let(:account) { create :account }
  let(:user_under_test) { create(:user) }
  before(:each) do
    Apartment::Tenant.switch! account.subdomain
    user_under_test.update role: create(:manage_users_role)
    sign_in user_under_test
  end

  describe "when user not logged in" do
    before(:each) { sign_out user_under_test }
    subject { response }
    let(:params) { {} }

    { index: :get, new: :get, create: :post, edit: :get, update: :put, destroy: :delete }.each do |action, method|
      describe "#{method}##{action}" do
        let(:params) { {id: user_under_test.id} } if [:edit, :update, :destroy].include? action
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

    %w{index new edit }.each do |action|
      describe "GET##{action}" do
        let(:params) { {id: user_under_test.id} } if action == 'edit'
        context "when user does not have permission" do
          before(:each) do
            case action
            when 'index' then user_under_test.update role: create(:role)
            when 'new'then user_under_test.role.update can_create_users: false
            when 'edit' then user_under_test.role.update can_update_users_role: false, can_update_users_password: false
            end
            get action, params
          end
          it { is_expected.to redirect_to(root_path) }
        end

        context "when user has permission" do
          before(:each) do
            user_under_test.update role: create(action == 'edit'? :update_users_role_role : :create_users_role)
            get action, params
          end
          it { is_expected.to have_http_status(:ok) }
          it { is_expected.to render_template(action) }
        end
      end
    end

    { create: :post, update: :put }.each do |action, method|
      context "when input param is blank" do
        describe "#{method}##{action}" do
          let(:id) { user_under_test.id }
          let(:params) { (action == :update)? {user: {}, id: id } : {user: {} } }
          it "raises exception" do
            expect { send(method, action, params) }.to raise_error(ActionController::ParameterMissing)
          end
        end
      end
    end

    describe "GET#new" do
      it "should create new instance of User(@user)" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST#create" do
      let(:email) { 'user@mail.com' }
      let(:role) { Role.last }
      let(:params) { { email: email, password: '12345678', role_id: role.id } }
      let(:template) { :new }

      context "when user does not have permission" do
        let(:user_params) { params }
        before(:each) do
          user_under_test.role.update can_create_users: false
          post :create, user: user_params
        end
        it { is_expected.to redirect_to(root_path) }
      end

      context "when user has permission" do
        before(:each) do
          user_under_test.update role: create(:create_users_role)
          post :create, user: user_params
        end

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
    end

    describe "PUT#update" do
      let(:role) { create(:role) }
      let(:params) { {password: '12345678', role_id: role.id} }
      let(:template) { :edit }
      let(:id) { user_under_test.id }

      context "when user does not have permission" do
        let(:user_params) { params }
        before(:each) do
          user_under_test.role.update can_update_users_role: false, can_update_users_password: false
          put :update, id: id, user: user_params
        end
        it { is_expected.to redirect_to(root_path) }
      end

      context "when user has permission" do
        context "when parameters invalid" do
          before(:each) { user_under_test.update role: create(:update_users_role_and_password_role) }
          context "when id wrong" do
            let(:user_params) { params }
            let(:user_id) { id+100 }
            subject { put :update, id: user_id, user: user_params }
            it {expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          end

          [:password, :role_id].each do |param|
            context "when #{param} wrong" do
              before(:each) { put :update, id: id, user: user_params }
              let(:user_params) { params.merge({ param => "wrong" }) }
              it_behaves_like "when user could not be created or updated"
            end
          end
        end

        context "when user has update role permission" do
          let(:user_params) { params }
          let!(:origin_password) {user_under_test.encrypted_password}
          before(:each) do
            user_under_test.update role: create(:update_users_role_role)
            allow(controller).to receive(:sign_in)
            put :update, id: id, user: user_params
          end
          it "updates user role" do
            expect(User.find(id).role).to eq role
          end
          it "does not update user password" do
            expect(User.find(id).encrypted_password).to eq(origin_password)
          end
          it "User.count not changed" do
            expect(User.count).to eq(user_count)
          end
          it { is_expected.to redirect_to(users_path) }
        end

        context "when user has update password permission" do
          let(:update_users_role) { :update_users_password_role }
          include_context "when user have update password permission"
          it "does not update user role" do
            expect(User.find(id).role).to eq @origin_role
          end
          it_behaves_like "when logged in user updates password"
        end

        context "when user has update role and update password permissions" do
          let(:update_users_role) { :update_users_role_and_password_role }
          include_context "when user have update password permission"
          it "updates user role" do
            expect(User.find(id).role).to eq role
          end
          it_behaves_like "when logged in user updates password"
        end
      end
    end

    describe "DELETE#destroy" do
      let(:id) { user_under_test.id }

      context "when user does not have permission" do
        let(:user_params) { params }
        before(:each) do
          user_under_test.role.update can_delete_users: false
          delete :destroy, id: id
        end
        it { is_expected.to redirect_to(root_path) }
      end

      context "when user has permission" do
        let(:some_user) { create(:user) }
        let(:id) { some_user.id }
        before(:each) { user_under_test.update role: create(:delete_users_role) }

        context "when id wrong" do
          let(:user_id) { id+100 }
          subject { delete :destroy, id: user_id }
          it {expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        end

        context "when successful" do
          before(:each) { delete :destroy, id: id }
          it "deletes user" do
            expect{some_user.reload}.to raise_error(ActiveRecord::RecordNotFound)
          end
          it "User.count decreased by 1" do
            expect(User.count).to eq(1)
          end
          it { is_expected.to redirect_to(users_path) }
        end

        context "when try to delete logged in user" do
          before(:each) { delete :destroy, id: id }
          it "does not delete user" do
            expect(user_under_test.reload).to be(user_under_test)
          end
          it "User.count not changed" do
            expect(User.count).to eq(user_count)
          end
          it { is_expected.to redirect_to(users_path) }
        end
      end
    end
  end
end
