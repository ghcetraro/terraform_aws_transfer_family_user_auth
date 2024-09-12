#
output "account_id" {
  description = "Account ID"
  value       = local.current_account
}
#
output "aws_transfer_server_url" {
  value = aws_transfer_server.transfer.url
}
#
output "aws_transfer_server_endpoint" {
  value = aws_transfer_server.transfer.endpoint
}
#
output "elastic_ip" {
  value = aws_eip.sftp.public_ip
}
#
output "sftp_dns" {
  value = var.transfer_defaults.dns_url
}

