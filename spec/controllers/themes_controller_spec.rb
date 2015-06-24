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
end
