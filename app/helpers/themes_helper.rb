module ThemesHelper
  UPLOADS_FOLDER = 'uploads/'

  def theme_upload_params
    return @theme_upload_params if @theme_upload_params

    bucket_name = Rails.application.config.aws_public_bucket_name
    redirect_url = request.protocol + request.host_with_port + '/themes/create_completed'

    @theme_upload_params = { form_action: "https://#{bucket_name}.s3.amazonaws.com/",
                             form_method: 'post',
                             form_enclosure_type: 'multipart/form-data',
                             acl: 'private',
                             redirect_url: redirect_url,
                             file_id: "#{UPLOADS_FOLDER}#{SecureRandom.uuid}_${filename}",
                             access_key: Rails.application.config.aws_access_key }

    conditions = [[:eq, :$bucket, bucket_name],
                  [:eq, :$acl, :private],
                  [:"content-length-range", 1, Rails.application.config.aws_max_theme_zip_file_length],
                  [:"starts-with", :$key, UPLOADS_FOLDER],
                  [:eq, :$success_action_redirect, redirect_url]]
    policy = { conditions: conditions, expiration: (Time.now + 10.hours).utc.iso8601 }
    policy = Base64.strict_encode64(policy.to_json)

    @theme_upload_params.merge! policy: policy
    @theme_upload_params.merge! signature:
                                Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),
                                                                            Rails.application.config.aws_secret_access_key,
                                                                            policy))
  end
end
