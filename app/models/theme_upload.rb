class ThemeUpload
  UPLOADS_FOLDER_NAME = "uploads"
  attr_reader :policy_conditions
  attr_reader :policy
  attr_reader :encoded_policy
  attr_reader :encoded_signature

  def initialize bucket_name, redirect_url
    @policy_conditions = [[:eq, :$bucket, bucket_name],
                          [:eq, :$acl, :private],
                          [:"content-length-range", 1, Rails.application.config.max_theme_zip_file_length],
                          [:"starts-with", :$key, UPLOADS_FOLDER_NAME + "/"],
                          [:eq, :$success_action_redirect, redirect_url]]
    @policy = { conditions: @policy_conditions, expiration: (Time.now + 10.hours).utc.iso8601 }
    @encoded_policy = Base64.strict_encode64(@policy.to_json)
    @encoded_signature = Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), Rails.application.config.aws_secret_access_key, @encoded_policy))
  end
end
