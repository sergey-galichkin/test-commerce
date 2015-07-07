require 'rails_helper'

RSpec.describe Role, type: :model do

  context "when validate" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_length_of(:name).is_at_most Role::NAME_LIMIT_MAX }
    it {expect(build(:role)).to validate_uniqueness_of(:name)}
    it {is_expected.to have_db_column(:name).with_options null: false, limit: Role::NAME_LIMIT_MAX }

    %w{ can_create_users can_update_users_password can_update_users_role can_delete_users }.each do |column_name|
        it {is_expected.to have_db_column(column_name).with_options null: false, default: false }
    end
  end
end
