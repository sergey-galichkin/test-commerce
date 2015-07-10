require 'rails_helper'

RSpec.describe Rails.application.config do
   describe "has set ActionMailer options" do
    subject { Rails.application.config.action_mailer }
    it {expect(subject.default_url_options).to include(:host) }
    it {expect(subject.raise_delivery_errors).to be_truthy }
    it {expect(subject.delivery_method).to eq :smtp }
    it {expect(subject.perform_deliveries).to be_truthy }
    it {expect(subject.smtp_settings).to include(:address, :port, :domain, :authentication, :enable_starttls_auto, :user_name, :password) }
  end
end
