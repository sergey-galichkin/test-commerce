require 'rails_helper'

RSpec.describe Role, type: :model do

  context "when validate" do
    it {is_expected.to validate_presence_of(:name)}

    it {expect(build(:role)).to validate_uniqueness_of(:name)}
  end

  #TODO: use shared example
  context "when tenant switch" do
    before(:each) do
      Apartment::Tenant.reset
      @role=create(:role)
    end
    after(:each) do
      Apartment::Tenant.drop('testdomain') rescue nil
    end

    it "is in public tenant before switch" do
      expect(@role.reload).to eq(@role)
    end

    it "is in public tenant after switch" do
      Apartment::Tenant.create('testdomain')
      Apartment::Tenant.switch! 'testdomain'
      expect(@role.reload).to eq(@role)
    end
  end


end
