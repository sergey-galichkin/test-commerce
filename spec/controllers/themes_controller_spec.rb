require 'rails_helper'

RSpec.shared_examples "creating Theme in DB" do |key, theme_name|
  before(:each) { get :create_completed, key: key }
  subject(:theme) { Theme.find_by_name theme_name }
  describe "Theme with name #{theme_name}" do
    it { is_expected.to be }
    its(:zip_file_url) { is_expected.to eq key }
    it { is_expected.to be_processing }
  end
end

RSpec.describe ThemesController, type: :controller do
  describe "GET #index" do
    subject { get :index }
    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:index) }
  end

  describe "GET #new" do
    subject { get :new }
    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:new) }
  end

  describe "GET #create_completed (redirect from AWS)" do
    context "with valid parameters" do
      {"_qwerty.zip" => "qwerty", "1234_qwerty.zip" => "qwerty", "12345_67890_qwerty.zip" => "67890_qwerty"}.each do |key, theme_name|
        context "when parsing key: #{key}" do
          subject { get :create_completed, key: key }
          it { is_expected.to redirect_to action: :index }
          it_behaves_like "creating Theme in DB", key, theme_name
        end
      end
    end

    context "when invalid parameters" do
      let(:theme_name) { "#{Faker::Lorem.sentence}zip" }
      let(:key) { "_#{theme_name}" }
      subject { get :create_completed, key: key }

      context "when wrong file extension (not .zip)" do
        let(:theme_name) { "#{Faker::Lorem.sentence}" }
        it { is_expected.to redirect_to action: :new }
      end

      context "when theme name blank" do
        let(:theme_name) { '' }
        it { is_expected.to redirect_to action: :new }
      end

      context "when key missing" do
      end
    end

    context "when theme already exists" do
    end
  end
end