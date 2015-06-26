RSpec.describe ThemeUpload do
  let(:url){ Faker::Internet.url }
  let(:bucket_name){ :bucket_name }
  subject { ThemeUpload.new bucket_name, url }

  context "has required configuration settings" do
    describe "max size of theme zip file" do
      it { expect(Rails.configuration.max_theme_zip_file_length).to be_between(1, 5*1024*1024*1024-1).inclusive }
    end

    describe "AWS secret key" do
      it { expect(Rails.configuration.aws_secret_key).to be_a String }
    end
  end

  context "when constructing policy" do
    let(:utc_now){ (Time.now + 10*60*60).utc.iso8601 }
    let(:utc_next_minute){ (Time.now + 10*60*60 + 60).utc.iso8601 }

    its(:policy) { is_expected.to be_a(Hash)}

    describe "policy expiration" do
      it { expect(subject.policy[:expiration]).to be_between utc_now, utc_next_minute }
    end

    its(:policy) { is_expected.to include(conditions: subject.policy_conditions)}
    its(:policy_conditions) { is_expected.to be_an Array}
    its(:policy_conditions) { is_expected.to include [:eq, :$bucket, :bucket_name] }
    its(:policy_conditions) { is_expected.to include [:eq, :$acl, :private] }
    its(:policy_conditions) { is_expected.to include [:"content-length-range", 1, Rails.configuration.max_theme_zip_file_length] }
    its(:policy_conditions) { is_expected.to include [:"starts-with", :$key, ThemeUpload::UPLOADS_FOLDER_NAME + "/"] }
    its(:policy_conditions) { is_expected.to include [:eq, :$success_action_redirect, url] }

    its(:encoded_policy) { is_expected.to eq Base64.encode64(subject.policy.to_json).gsub("\n","")}

    its(:encoded_signature) { is_expected.to eq Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), Rails.configuration.aws_secret_key, subject.encoded_policy)).gsub("\n","")}
  end
end
