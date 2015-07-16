module AmazonAwsClient
  def self.client
    credentials = Aws::Credentials.new Rails.application.config.aws_access_key, Rails.application.config.aws_secret_access_key
    Aws::S3::Client.new region: Rails.application.config.aws_region, credentials: credentials
  end

  def self.transfer_from_public_to_private_bucket key
    client = self.client
    client.copy_object(bucket: Rails.application.config.aws_private_bucket_name,
                       key: key,
                       copy_source: Rails.application.config.aws_public_bucket_name + '/' + key)
    client.delete_object bucket: Rails.application.config.aws_public_bucket_name, key: key
  end

  def self.delete_from_public_bucket key
    self.client.delete_object bucket: Rails.application.config.aws_public_bucket_name, key: key
  end
end
