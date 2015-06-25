RSpec.shared_examples "adding first policy condition" do
  its(:policy_conditions) { is_expected.to include [:condition, :param_1, :param_2] }
end

RSpec.describe ThemeUpload, type: :model do
  context "has required configuration settings" do
    describe "max size of theme zip file" do
      it { expect(Rails.configuration.max_theme_zip_file_length).to be_between(1, 5*1024*1024*1024-1).inclusive }
    end
  end

  context "when initialized" do
    its(:policy_conditions) { is_expected.to eq []}
  end

  context "when adding policy condition" do
    before(:each) { subject.add_policy_condition :condition, :param_1, :param_2 }

    it_behaves_like "adding first policy condition"

    context "and adding second policy condition" do
      before(:each) { subject.add_policy_condition :another_condition, :another_param_1, :another_param_2 }
      it_behaves_like "adding first policy condition"
      its(:policy_conditions) { is_expected.to include [:another_condition, :another_param_1, :another_param_2] }
    end
  end

  context "when adding bucket policy condition" do
    its(:policy_conditions) { expect(subject.add_bucket_policy_condition :bucket_name).to include [:eq, :$bucket, :bucket_name] }
  end

  context "when adding acl policy condition" do
    its(:policy_conditions) { expect(subject.add_acl_policy_condition).to include [:eq, :$acl, :private] }
  end

  context "when adding content length policy condition" do
    its(:policy_conditions) { expect(subject.add_content_length_policy_condition).to include [:"content-length-range", 1, Rails.configuration.max_theme_zip_file_length] }
  end

  context "when adding key policy condition" do
    its(:policy_conditions) { expect(subject.add_key_policy_condition).to include [:"starts-with", :$key, ThemeUpload::UPLOADS_FOLDER_NAME + "/"] }
  end

  context "when adding redirect policy condition" do
    let(:url){ Faker::Internet.url }
    its(:policy_conditions) { expect(subject.add_redirect_policy_condition url).to include [:eq, :$success_action_redirect, url] }
  end
end
