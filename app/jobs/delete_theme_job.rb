class DeleteThemeJob < ActiveJob::Base
  queue_as :low_priority

  rescue_from(Aws::S3::Errors::RequestTimeout) do
    retry_job wait: 5.minutes, queue: :low_priority
  end

  def perform(zip_file_url, is_public_bucket)
    AmazonAwsClient.try (is_public_bucket ? :delete_from_public_bucket : :delete_from_private_bucket), zip_file_url
  end
end
