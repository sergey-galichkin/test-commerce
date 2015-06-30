require 'rails_helper'

RSpec.describe Theme, type: :model do
  context "when validate" do
    it {is_expected.to validate_presence_of :name}
    it {expect(build(:theme)).to validate_uniqueness_of(:name).case_insensitive }
    it {expect(build(:theme)).to validate_length_of(:name).is_at_most Theme::NAME_LIMIT }
    it {is_expected.to have_db_column(:name).with_options limit: Theme::NAME_LIMIT, null: false }

    it {is_expected.to validate_presence_of :zip_file_url}
    it {expect(build(:theme)).to validate_uniqueness_of(:zip_file_url).case_insensitive}
    it {is_expected.to validate_length_of(:zip_file_url).is_at_most Theme::ZIP_FILE_URL_LIMIT }
    it {is_expected.to have_db_column(:zip_file_url).with_options limit: Theme::ZIP_FILE_URL_LIMIT, null: false }

    it {is_expected.to validate_presence_of :status}
    it {is_expected.to have_db_column(:status).with_options null: false, default: 0}
  end
end