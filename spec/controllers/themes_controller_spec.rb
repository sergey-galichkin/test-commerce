require 'rails_helper'

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
    before (:all) { create :processing_theme_status }

    context "with valid parameters" do
      let(:theme_name) { "#{Faker::Lorem.sentence}zip" }
      let(:key) { "_#{theme_name}" }
      subject { get :create_completed, key: key }
      it { is_expected.to redirect_to action: :index }
    end

    context "when parsing theme name in key" do
      {"_qwerty" => "qwerty", "1234_qwerty" => "qwerty", "12345_67890_qwerty" => "67890_qwerty"}.each do |key, theme_name|
        it "creates Theme in DB when key is #{key}" do
          get :create_completed, key: key
          expect(Theme.find_by_name(theme_name)).to be_a Theme
        end
      end
    end
  end
end