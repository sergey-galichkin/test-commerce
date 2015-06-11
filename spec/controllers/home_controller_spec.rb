require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET start page" do
  	it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
  	end
    
    it "renders index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
