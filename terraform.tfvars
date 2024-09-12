#
customer    = "devops"
environment = "production"
region      = "us-east-1"
#
transfer_defaults = {
  name    = "sftp_general_purpose"
  dns_url = "sftp.moon.io"
}
#
api_gateway_defaults = {
  name       = "sftp_general_purpose"
  deployment = "prod"
}
#
lambda_defaults = {
  name        = "sftp_general_purpose"
  runtime     = "python3.11"
  handler     = "index.lambda_handler"
  timeout     = "5"
  memory_size = "128"
}
#
secret_manager_defaults = {
  moon = {
    sftp_user            = "sftp-production"
    role                 = "arn:aws:iam::<aacount>:role/sftp-production_client"
    bucket               = "sftp-production-data"
    HomeDirectoryDetails = "[{\\\"Entry\\\":\\\"/client-submit\\\",\\\"Target\\\":\\\"/sftp-production-data/client\\\"},{\\\"Entry\\\":\\\"/extracts\\\",\\\"Target\\\":\\\"/sftp-production-data/extracts\\\"}]"
  },
}
