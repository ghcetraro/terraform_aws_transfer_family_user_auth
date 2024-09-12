#
resource "aws_transfer_server" "transfer" {
  identity_provider_type = "API_GATEWAY"
  url                    = "${aws_api_gateway_deployment.apirest.invoke_url}${var.api_gateway_defaults.deployment}"
  #
  endpoint_type = "VPC"
  endpoint_details {
    address_allocation_ids = [aws_eip.sftp.id]
    subnet_ids             = [local.vpc.public_subnets]
    vpc_id                 = local.vpc.id
    security_group_ids     = [aws_security_group.allow_tls.id]
  }
  #
  logging_role    = aws_iam_role.TransferIdentityProviderRole.arn
  invocation_role = aws_iam_role.TransferIdentityProviderRole.arn
  #
  protocols   = ["SFTP"]
  certificate = local.acm.certificate_arn_private
  #
  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]
  #
  tags = merge(
    local.tags,
    {
      "Name" = var.transfer_defaults.name,
    }
  )
  #
  depends_on = [
    aws_iam_role.TransferIdentityProviderRole,
    aws_api_gateway_rest_api.apirest,
    aws_eip.sftp,
  ]
}