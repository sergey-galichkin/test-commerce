require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid with empty email"
  it "is invalid with empty password"
  it "must have unique email"
  it "is assigned AccountOwner role when created with new Account"
end
