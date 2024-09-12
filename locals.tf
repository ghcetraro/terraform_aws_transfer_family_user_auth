locals {
  app_name_dashed = "${var.customer}-${var.environment}"
  #
  aws_profile = "${var.customer}-${var.environment}"
  #
  tags = {
    application_name = local.app_name_dashed
    environment      = var.environment
    provisioner      = "terraform"
  }
  #
  current_account     = data.aws_caller_identity.current.account_id
  current_api_gateway = aws_api_gateway_rest_api.apirest.id
  current_transfer_id = aws_transfer_server.transfer.id
  #
  dns = {
    zone_id = " " # to fill
  }
  #
  vpc = {
    id             = " " # to fill
    public_subnets = " " # to fill
  }                      #
  acm = {
    certificate_arn_private = "arn:aws:acm:<region>:<account>:certificate/<id>" # to fill
  }
}