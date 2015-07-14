require 'rails_helper'

RSpec.describe Rails.application.config do
   describe "has set Amazon S3 options" do
    it {expect(subject.aws_max_theme_zip_file_length).to be_between(1, 5.gigabytes - 1).inclusive }
    it { expect(subject.aws_access_key).to be_a String }
    it { expect(subject.aws_secret_access_key).to be_a String }
    it { expect(subject.aws_public_bucket_name).to be_a String }
  end
end