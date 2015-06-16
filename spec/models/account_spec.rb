require 'rails_helper'

RSpec.describe Account, type: :model do

  context "when validate" do

    it {is_expected.to validate_presence_of(:name)}

    it {is_expected.to validate_presence_of(:subdomain)}

    it {expect(build(:account)).to validate_uniqueness_of(:subdomain).case_insensitive}
  end

  context "when tenant switch" do
    before(:each) do
      Apartment::Tenant.reset
      @acc=create(:account)
    end
    after(:each) do
      Apartment::Tenant.drop('testdomain') rescue nil
    end

    it "is in public tenant before switch" do
      expect(@acc.reload).to eq(@acc)
    end

    it "is in public tenant after switch" do
      Apartment::Tenant.create('testdomain')
      Apartment::Tenant.switch! 'testdomain'
      expect(@acc.reload).to eq(@acc)
    end
  end

end
