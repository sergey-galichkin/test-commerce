require 'rails_helper'

RSpec.describe Account, type: :model do

  let(:acc) { create(:account) }

  context "when validate" do

    it {is_expected.to validate_presence_of(:name)}

    it {is_expected.to validate_presence_of(:subdomain)}

    it {expect(build(:account)).to validate_uniqueness_of(:subdomain).case_insensitive}
  end

  context "when create" do
    it "creates tenant" do
      expect { Apartment::Tenant.switch! acc.subdomain }.not_to raise_error
    end
  end

  context "when destroy" do
    it "drops tenant" do
      subdomain= acc.subdomain
      acc.destroy
      expect { Apartment::Tenant.switch! subdomain }.to raise_error(Apartment::TenantNotFound)
    end
  end
end
