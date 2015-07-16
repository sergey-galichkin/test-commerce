require 'rails_helper'

RSpec.describe TransferThemeJob, type: :job do
  include ActiveJob::TestHelper

  let(:theme) { create(:theme) }
  subject(:job) { described_class.perform_later(theme) }

  describe "when queued" do

    it "queues the job" do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it "is in default queue" do
      expect(TransferThemeJob.new.queue_name).to eq('default')
    end
  end

  describe "when executes perform" do
    it "transfer theme from public to private bucket" do
      expect(AmazonAwsClient).to receive(:transfer_from_public_to_private_bucket).with(theme.zip_file_url)
      perform_enqueued_jobs { job }
    end
    it "updates theme status" do
      allow(AmazonAwsClient).to receive(:transfer_from_public_to_private_bucket)
      perform_enqueued_jobs { job }
      expect(theme.reload.uploaded?).to be_truthy
    end
  end
end
