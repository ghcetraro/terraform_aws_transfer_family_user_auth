#
resource "aws_secretsmanager_secret" "sftp" {
  #
  name = "aws/transfer/${var.current_transfer_id}/${var.sftp_user}"
  tags = var.tags
}
#
resource "random_password" "sftp" {
  length      = 8
  min_lower   = 2
  min_numeric = 4
  min_special = 0
  min_upper   = 2
  special     = false
}
#
resource "aws_secretsmanager_secret_version" "sftp" {
  secret_id     = aws_secretsmanager_secret.sftp.id
  secret_string = <<EOF
  {
"Password" : "${random_password.sftp.result}",
"Role" : "${var.role}",
"HomeDirectory" : "/${var.bucket}",
"HomeDirectoryDetails" : "${var.HomeDirectoryDetails}"
   }
EOF
  #
  depends_on = [
    aws_secretsmanager_secret.sftp,
    random_password.sftp,
  ]
}
#
