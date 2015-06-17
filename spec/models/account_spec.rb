require 'rails_helper'

RSpec.describe Account, type: :model do

  context "when validate" do

    it {is_expected.to validate_presence_of(:name)}

    it {is_expected.to validate_presence_of(:subdomain)}

    it {expect(build(:account)).to validate_uniqueness_of(:subdomain).case_insensitive}
  end
end
