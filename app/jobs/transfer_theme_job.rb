class TransferThemeJob < ActiveJob::Base
  queue_as :default

  def perform(theme)
    # TODO: consider Aws::S3::Errors:... handling and retry job if error is recoverable (e.g. network problem)
    AmazonAwsClient.transfer_from_public_to_private_bucket theme.zip_file_url
    theme.update! status: :uploaded
  end
end
