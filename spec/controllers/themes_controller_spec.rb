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
      before (:all) { ThemeStatus.create! name: :Processing }
      
      let(:theme_name) { "#{Faker::Lorem.sentence}zip" }
      let(:key) { "_#{theme_name}" }
      
      subject { get :create_completed, key: key }
      
      it "creates Theme in DB" do
        subject
        puts "RSPEC THEMES: #{Theme.all[0]}"
        expect(Theme.find_by_name(theme_name)).to be_a Theme
      end
      it { is_expected.to redirect_to action: :index }
    end
  end
end