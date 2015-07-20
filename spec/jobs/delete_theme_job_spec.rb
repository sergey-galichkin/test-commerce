require 'rails_helper'

RSpec.describe DeleteThemeJob, type: :job do
  include ActiveJob::TestHelper
  let(:zip_file_url) { 'some_zip_file_url' }
  let(:is_public_bucket) { true }
  subject(:job) { described_class.perform_later(zip_file_url, is_public_bucket) }

  describe "when queued" do
    it "queues the job" do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
    it "is in default queue" do
      expect(DeleteThemeJob.new.queue_name).to eq('default')
    end
  end

  describe "when executes perform" do
    it "deletes theme from public bucket" do
      expect(AmazonAwsClient).to receive(:delete_from_public_bucket).with(zip_file_url)
      perform_enqueued_jobs { job }
    end
    describe "when theme in private bucket" do
      let(:is_public_bucket) { false }
      it "deletes theme from private bucket" do
        expect(AmazonAwsClient).to receive(:delete_from_private_bucket).with(zip_file_url)
        perform_enqueued_jobs { job }
      end
    end
  end
end