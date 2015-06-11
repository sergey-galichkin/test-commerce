require 'rails_helper'

RSpec.describe Account, type: :model do
  it "is invalid with empty name"
  it "is invalid with empty subdomain"
  it "has unique subdomain"
end
