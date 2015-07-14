require 'rails_helper'

RSpec.describe ThemesHelper, type: :helper do  
  describe "#theme_upload_params" do
    let(:redirect_url) {"http://test.host/themes/create_completed" }
    let (:policy) {
      timestamp = Time.now
      allow(Time).to receive(:now).and_return(timestamp)
      conditions = [[:eq, :$bucket, Rails.application.config.aws_public_bucket_name],
                    [:eq, :$acl, :private],
                    [:"content-length-range", 1, Rails.application.config.aws_max_theme_zip_file_length],
                    [:"starts-with", :$key, "#{ThemesHelper::UPLOADS_FOLDER}"],
                    [:eq, :$success_action_redirect, redirect_url]]
      policy = { conditions: conditions, expiration: (Time.now + 10.hours).utc.iso8601 }
      policy = Base64.strict_encode64(policy.to_json) }

    subject {helper.theme_upload_params}

    it {is_expected.to be_a Hash}

    it "has form_action key with value" do
      expect(subject[:form_action]).to eq "https://#{Rails.application.config.aws_public_bucket_name}.s3.amazonaws.com/"
    end
    it "has form_method key with value" do
      expect(subject[:form_method]).to eq "post"
    end
    it "has form_enclosure_type key with value" do
      expect(subject[:form_enclosure_type]).to eq "multipart/form-data"
    end
    it "has acl key with value" do
      expect(subject[:acl]).to eq "private"
    end
    it "has access_key key with value" do
      expect(subject[:access_key]).to eq Rails.application.config.aws_access_key
    end
    it "has redirect_url key with value" do
      expect(subject[:redirect_url]).to eq redirect_url
    end
    it "has file_id key with value" do
      uuid= SecureRandom.uuid
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
      expect(subject[:file_id]).to eq "#{ThemesHelper::UPLOADS_FOLDER}#{SecureRandom.uuid}_${filename}"
    end
    it "has policy key with value" do
      expect(subject[:policy]).to eq policy
    end

    it "has signature key with value" do
      expect(subject[:signature]).to eq Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),
                                                               Rails.application.config.aws_secret_access_key, policy))
    end
  end
end