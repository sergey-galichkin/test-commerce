require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) { create :theme}
  subject { theme }

  context "when validate" do
    it {is_expected.to validate_presence_of :name}
    it {expect(build(:theme)).to validate_uniqueness_of(:name).case_insensitive }
    it {expect(build(:theme)).to validate_length_of(:name).is_at_most Theme::NAME_LIMIT }
    it {is_expected.to have_db_column(:name).with_options limit: Theme::NAME_LIMIT, null: false }

    it {is_expected.to validate_presence_of :zip_file_url}
    it {expect(build(:theme)).to validate_uniqueness_of(:zip_file_url).case_insensitive}
    it {is_expected.to validate_length_of(:zip_file_url).is_at_most Theme::ZIP_FILE_URL_LIMIT }
    it {is_expected.to have_db_column(:zip_file_url).with_options limit: Theme::ZIP_FILE_URL_LIMIT, null: false }
    %w{filename.zip filename.ZIP filename.ZiP}.each do |filename|
        it {is_expected.to allow_value(filename).for(:zip_file_url) }
    end
    %w{filename filename. filename.z filename.zi filename.abc filename.ziip}.each do |filename|
        it {is_expected.to_not allow_value(filename).for(:zip_file_url) }
    end
    it {is_expected.to validate_presence_of :status}
    it {is_expected.to have_db_column(:status).with_options null: false, default: Theme.statuses[:processing]}
  end

  context "when create" do
    context "when successfull" do
      it "schedules transfer theme from public to private bucket" do
        expect { subject }.to enqueue_a(TransferThemeJob).with(global_id(Theme))
      end
      it "does not schedules deletion theme from public bucket" do
        expect { subject }.to_not enqueue_a(DeleteThemeJob).with(String, TrueClass)
      end
    end
    context "when unsuccessfull" do
      let(:theme) { build :theme, zip_file_url: "wrong_url" }
      it "schedules deletion theme from public bucket" do
        expect { theme.save }.to enqueue_a(DeleteThemeJob).with(String, TrueClass)
      end
      it "schedules transfer theme from public to private bucket" do
        expect { theme.save }.to_not enqueue_a(TransferThemeJob).with(global_id(Theme))
      end
    end
  end

  context "when destroy" do
    it "schedules deletion theme from public bucket" do
      expect { theme.destroy }.to enqueue_a(DeleteThemeJob).with(String, TrueClass)
    end
    it "schedules deletion theme from private bucket" do
      theme.update status: :uploaded
      expect { theme.destroy }.to enqueue_a(DeleteThemeJob).with(String, FalseClass)
    end
  end
end
