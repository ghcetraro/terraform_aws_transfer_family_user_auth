######### public records ########################################
resource "aws_route53_record" "dns" {
  zone_id = local.dns.zone_id
  name    = var.transfer_defaults.dns_url
  type    = "CNAME"
  ttl     = 60
  records = [aws_transfer_server.transfer.endpoint]
  #
  depends_on = [
    aws_transfer_server.transfer,
    aws_eip.sftp,
  ]
}