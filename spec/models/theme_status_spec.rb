require 'rails_helper'

RSpec.describe ThemeStatus, type: :model do
  context "when validate" do
    it {is_expected.to validate_presence_of :name}
    it {expect(build(:theme_status)).to validate_uniqueness_of(:name).case_insensitive }
    it {is_expected.to validate_length_of(:name).is_at_most ThemeStatus::NAME_LIMIT }
    it {is_expected.to have_db_column(:name).with_options limit: ThemeStatus::NAME_LIMIT, null: false}
  end
end
