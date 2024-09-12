#
resource "aws_cloudwatch_log_group" "transfer" {
  name              = "/aws/transfer/${var.transfer_defaults.name}"
  retention_in_days = var.cloudwatch_retention
  tags              = local.tags
}
#
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.lambda_defaults.name}"
  retention_in_days = var.cloudwatch_retention
  tags              = local.tags
}
#