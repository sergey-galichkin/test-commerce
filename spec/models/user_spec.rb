require 'rails_helper'

RSpec.describe User, type: :model do

  it {is_expected.to validate_presence_of(:email)}

  it {is_expected.to validate_presence_of(:password)}

  it {expect(build(:user)).to validate_uniqueness_of(:email)}

  it {is_expected.to belong_to(:role)}

end
