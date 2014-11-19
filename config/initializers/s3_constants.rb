# if Rails.env.development?
#   S3_KEY = "AKIAIVSYAS7CZYEEXZKQ"
#   S3_SECRET = "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"
# end




CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => "AKIAIVSYAS7CZYEEXZKQ",
      :aws_secret_access_key  => "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",
      :region                 => 'us-west-1'
  }
  config.fog_directory  = 'mp-devbucket'
end