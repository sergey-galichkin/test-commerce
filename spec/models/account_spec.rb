require 'rails_helper'

RSpec.describe Account, type: :model do
  it "has a valid factory" do
    expect(build(:account)).to be_valid
  end

  it "is invalid with empty name" do
    expect(build(:account, name: nil)).to be_invalid
  end

  it "is invalid with empty subdomain" do
    expect(build(:account, subdomain: nil)).to be_invalid
  end

  it "has unique subdomain"
end
