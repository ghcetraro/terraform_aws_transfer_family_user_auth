############### transfer ################
#
data "aws_iam_policy_document" "TransferIdentityProviderRole" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "transfer.amazonaws.com"
      ]
    }
  }
}
#
resource "aws_iam_role" "TransferIdentityProviderRole" {
  name               = "TransferIdentityProviderR-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.TransferIdentityProviderRole.json
  tags               = local.tags
}
#
resource "aws_iam_policy" "TransferCanReadThisApi" {
  name   = "TransferIdentityProviderRole-${var.environment}"
  policy = file("manifests/TransferCanReadThisApi.json")
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "TransferCanReadThisApi" {
  policy_arn = aws_iam_policy.TransferCanReadThisApi.id
  role       = aws_iam_role.TransferIdentityProviderRole.name
  depends_on = [aws_iam_role.TransferIdentityProviderRole]
}
#
data "aws_iam_policy_document" "TransferCanInvokeThisApi" {
  statement {
    effect  = "Allow"
    actions = ["execute-api:Invoke"]
    #resources = ["arn:aws:execute-api:${var.region}:${local.current_account}:${local.current_api_gateway}/prod/GET/*"]
    resources = ["*"]
  }
}
#
resource "aws_iam_policy" "TransferCanInvokeThisApi" {
  name   = "TransferCanInvokeThisApi-${var.environment}"
  policy = data.aws_iam_policy_document.TransferCanInvokeThisApi.json
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "TransferCanInvokeThisApi" {
  policy_arn = aws_iam_policy.TransferCanInvokeThisApi.id
  role       = aws_iam_role.TransferIdentityProviderRole.name
  depends_on = [aws_iam_role.TransferIdentityProviderRole]
}
#
resource "aws_iam_role_policy_attachment" "AWSTransferLoggingAccess" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"
  role       = aws_iam_role.TransferIdentityProviderRole.name
  depends_on = [aws_iam_role.TransferIdentityProviderRole]
}
#
################################ api gateway #################################################
#
data "aws_iam_policy_document" "apigateway" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com",
      ]
    }
  }
}
#
resource "aws_iam_role" "apigateway" {
  name               = "apigateway-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.apigateway.json
  tags               = local.tags
}
#
resource "aws_iam_policy" "apigateway" {
  name   = "ApiGatewayLogsPolicy-${var.environment}"
  policy = file("manifests/ApiGatewayLogsPolicy.json")
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "apigateway" {
  policy_arn = aws_iam_policy.apigateway.id
  role       = aws_iam_role.apigateway.name
  depends_on = [aws_iam_role.apigateway]
}
#
data "aws_iam_policy_document" "aws_policy_api" {
  statement {
    sid    = "DescribeLogStreams"
    effect = "Allow"
    #actions = [ "logs:*" ]
    actions   = ["*"]
    resources = ["*"]
  }
}
#
resource "aws_iam_policy" "aws_policy_api" {
  name   = "ApiGatewayLogsPolicy-logs-${var.environment}"
  policy = data.aws_iam_policy_document.aws_policy_api.json
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "api-role-policy-attachment" {
  role       = aws_iam_role.apigateway.name
  policy_arn = aws_iam_policy.aws_policy_api.arn
}
#
resource "aws_iam_role_policy_attachment" "api" {
  role       = aws_iam_role.apigateway.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
#
######################### lambda ########################################################
#
data "aws_iam_policy_document" "LambdaExecutionRole" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
#
resource "aws_iam_role" "LambdaExecutionRole" {
  name               = "LambdaExecutionRole-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.LambdaExecutionRole.json
  tags               = local.tags
}
#
resource "aws_iam_policy" "LambdaExecutionRole" {
  name   = "LambdaSecretsPolicy-${var.environment}"
  policy = file("manifests/LambdaSecretsPolicy.json")
  tags   = local.tags
}
#
resource "aws_iam_role_policy_attachment" "LambdaExecutionRole" {
  policy_arn = aws_iam_policy.LambdaExecutionRole.id
  role       = aws_iam_role.LambdaExecutionRole.name
  depends_on = [aws_iam_role.LambdaExecutionRole]
}
#
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.LambdaExecutionRole.name
  depends_on = [aws_iam_role.LambdaExecutionRole]
}
#
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["*"]
  }
}
#
resource "aws_iam_policy" "lambda_logging" {
  name   = "lambda_logging"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_logging.json
}
#
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.LambdaExecutionRole.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}