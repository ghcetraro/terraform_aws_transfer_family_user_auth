#
data "archive_file" "lambda_code_archive" {
  type        = "zip"
  source_dir  = "lambda-functions/auth"
  output_path = "lambda-functions/auth.zip"
}
#
resource "aws_lambda_function" "lambda" {
  #
  function_name    = var.lambda_defaults.name
  filename         = data.archive_file.lambda_code_archive.output_path
  source_code_hash = data.archive_file.lambda_code_archive.output_base64sha256
  role             = aws_iam_role.LambdaExecutionRole.arn
  runtime          = var.lambda_defaults.runtime
  handler          = var.lambda_defaults.handler
  memory_size      = var.lambda_defaults.memory_size
  timeout          = var.lambda_defaults.timeout
  #
  environment {
    variables = {
      SecretsManagerRegion = var.region
    }
  }
  tags = local.tags
  depends_on = [
    data.archive_file.lambda_code_archive,
    aws_iam_role.LambdaExecutionRole,
    aws_cloudwatch_log_group.lambda,
  ]
}
#
resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowAPIGatewayInvoke"
  source_arn    = "${aws_api_gateway_rest_api.apirest.execution_arn}/*"
}