require 'rails_helper'

RSpec.shared_examples "creating Theme in DB" do |key, theme_name|
  before(:each) { get :create_completed, key: key }
  subject(:theme) { Theme.find_by_name theme_name }
  describe "Theme with name #{theme_name}" do
    it { is_expected.to be }
    its(:zip_file_url) { is_expected.to eq key }
    it { is_expected.to be_processing }
    it { expect(Theme.count).to eq(1) }
  end
end

RSpec.shared_examples "uncussessfull create_completed" do
  it { expect(Theme.count).to be_zero }
  it { is_expected.to redirect_to action: :new }
  it "should set flash" do
    subject
    expect(controller).to set_flash[:alert]
  end
end

RSpec.describe ThemesController, type: :controller do
  let(:account) { create :account }
  let(:user_under_test) { create(:user) }
  before(:each) do
    Apartment::Tenant.switch! account.subdomain
    user_under_test.update role: create(:manage_themes_role)
    sign_in user_under_test
  end

  describe "when user not logged in" do
    before(:each) { sign_out user_under_test }
    subject { response }
    let(:params) { {} }

    { index: :get, new: :get, create_completed: :get, destroy: :delete }.each do |action, method|
      describe "#{method}##{action}" do
        let(:params) { {id: create(:theme).id} } if action == :destroy
        before(:each) { send(method, action, params) }
        it { is_expected.to have_http_status(:found) }
        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end

  describe "when user logged in" do
    subject { response }
    %w{ index new }.each do |action|
      describe "GET##{action}" do
        context "when user does not have permission" do
          before(:each) do
            case action
              when 'index' then user_under_test.update role: create(:role)
              when 'new' then user_under_test.role.update can_create_themes: false
            end
            get action
          end
          it { is_expected.to redirect_to(root_path) }
        end
        context "when user has permission" do
          before(:each) do
            user_under_test.update role: create(:create_themes_role)
            get action
          end
          it { is_expected.to have_http_status(:ok) }
          it { is_expected.to render_template(action) }
        end
      end
    end

    describe "GET#create_completed (redirect from AWS)" do
      let!(:theme_count){ Theme.count }
      context "when user does not have permission" do
        let(:key) { "1234_qwerty.zip" }
        before(:each) do
          user_under_test.role.update can_create_themes: false
          get :create_completed, key: key
        end
        it { is_expected.to redirect_to(root_path) }
      end
      context "when user has permission" do
        let(:theme_name) { "#{Faker::Internet.url}.zip" }
        let(:key) {"#{SecureRandom.uuid}_#{theme_name}"}
        subject { get :create_completed, key: key }
        context "with valid parameters" do
          {"_qwerty.zip" => "qwerty", "1234_qwerty.zip" => "qwerty", "12345_67890_qwerty.zip" => "67890_qwerty"}.each do |key, theme_name|
            context "when parsing key: #{key}" do
              it_behaves_like "creating Theme in DB", key, theme_name
              it { is_expected.to redirect_to action: :index }
              it "should set flash" do
                subject
                expect(controller).to set_flash[:notice]
              end
            end
          end
          context "when theme already exists" do
            let(:existing_theme) { create(:theme) }
            let(:key) {"#{SecureRandom.uuid}_#{existing_theme.name}.zip"}
            it_behaves_like "uncussessfull create_completed"
          end
        end
        context "when invalid parameters" do
          context "when wrong file extension (not .zip)" do
            let(:theme_name) { "#{Faker::Internet.url}.rar" }
            subject { get :create_completed, key: key }
            it_behaves_like "uncussessfull create_completed"
          end
          context "when theme name blank" do
            let(:theme_name) { '' }
            it_behaves_like "uncussessfull create_completed"
          end
          context "when params missing" do
            it "raises exception" do
              expect { get :create_completed }.to raise_error(ActionController::ParameterMissing)
            end
          end
        end
      end
    end

    describe "DELETE#destroy" do
      let(:theme) { create(:theme) }
      let(:id) { theme.id }
      context "when user does not have permission" do
        before(:each) do
          user_under_test.role.update can_delete_themes: false
          delete :destroy, id: id
        end
        it { is_expected.to redirect_to(root_path) }
      end

      context "when user has permission" do
        context "when id wrong" do
          let(:id) { theme.id+100 }
          subject { delete :destroy, id: id }
          it "raises exception" do
            expect {subject}.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
        context "when successful" do
          before(:each) do
            id = theme.id
            @count = Theme.count
            delete :destroy, id: id
          end
          it "deletes theme" do
            expect{theme.reload}.to raise_error(ActiveRecord::RecordNotFound)
          end
          it "Theme.count decreased by 1" do
            expect(Theme.count).to eq(@count-1)
          end
          it { is_expected.to redirect_to(themes_path) }
        end
      end
    end
  end
end
