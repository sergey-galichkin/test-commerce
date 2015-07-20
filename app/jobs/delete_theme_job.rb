class DeleteThemeJob < ActiveJob::Base
  queue_as :default

  def perform(zip_file_url, is_public_bucket)
    # TODO: consider Aws::S3::Errors:... handling and retry job if error is recoverable (e.g. network problem)
    AmazonAwsClient.try (is_public_bucket ? :delete_from_public_bucket : :delete_from_private_bucket), zip_file_url
  end
end
