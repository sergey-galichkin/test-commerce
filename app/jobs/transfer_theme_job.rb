class TransferThemeJob < ActiveJob::Base
  queue_as :default

  rescue_from(Aws::S3::Errors::RequestTimeout) do
    retry_job wait: 5.minutes, queue: :default
  end

  def perform(theme)
    AmazonAwsClient.transfer_from_public_to_private_bucket theme.zip_file_url
    theme.update! status: :uploaded
  end
end
