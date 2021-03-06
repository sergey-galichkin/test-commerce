require 'rails_helper'

RSpec.describe User, type: :model do

  context "when validate" do
    it {is_expected.to validate_presence_of(:email)}

    it {is_expected.to validate_presence_of(:password)}

    it {expect(build(:user)).to validate_uniqueness_of(:email)}

    it {is_expected.to validate_presence_of(:role)}

    it {is_expected.to belong_to(:role)}

    it {is_expected.to have_db_column(:role_id).with_options null: false}
  end
end
