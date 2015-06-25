class ThemeUpload
  UPLOADS_FOLDER_NAME = "uploads"
  attr_reader :policy_conditions

  def initialize
    @policy_conditions = Array.new
  end

  def add_policy_condition condition, param1, param2
    @policy_conditions << [condition, param1, param2]
  end

  def add_bucket_policy_condition bucket_name
    add_policy_condition :eq, :$bucket, bucket_name
  end

  def add_acl_policy_condition
    add_policy_condition :eq, :$acl, :private
  end

  def add_content_length_policy_condition
    add_policy_condition :"content-length-range", 1, Rails.configuration.max_theme_zip_file_length
  end

  def add_key_policy_condition
    add_policy_condition :"starts-with", :$key, UPLOADS_FOLDER_NAME + "/"
  end

  def add_redirect_policy_condition redirect_url
    add_policy_condition :eq, :$success_action_redirect, redirect_url
  end
end
