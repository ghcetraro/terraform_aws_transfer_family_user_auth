#
resource "aws_api_gateway_rest_api" "apirest" {
  #name = data.aws_api_gateway_rest_api.apirest.name
  name = var.api_gateway_defaults.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.tags
}
#
resource "aws_api_gateway_resource" "apirest" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  parent_id   = aws_api_gateway_rest_api.apirest.root_resource_id
  path_part   = "servers"
}
#
resource "aws_api_gateway_resource" "serverId" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  parent_id   = aws_api_gateway_resource.apirest.id
  path_part   = "{serverId}"
}
#
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  parent_id   = aws_api_gateway_resource.serverId.id
  path_part   = "users"
}
#
resource "aws_api_gateway_resource" "username" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{username}"
}
#
resource "aws_api_gateway_resource" "config" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  parent_id   = aws_api_gateway_resource.username.id
  path_part   = "config"
}
###################
resource "aws_api_gateway_method" "Method" {
  rest_api_id   = aws_api_gateway_rest_api.apirest.id
  resource_id   = aws_api_gateway_resource.config.id
  http_method   = "GET"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.PasswordBase64" = false
    "method.request.querystring.protocol"  = false
    "method.request.querystring.sourceIp"  = false
  }
}
#
resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.apirest.id
  resource_id             = aws_api_gateway_resource.config.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda.invoke_arn
  timeout_milliseconds    = "2900"
  request_templates = {
    "application/json" = "${file("manifests/api_gateway_body_mapping.template")}"
  }
}
resource "aws_api_gateway_model" "Method" {
  rest_api_id  = aws_api_gateway_rest_api.apirest.id
  name         = "UserConfigResponseModel"
  description  = "API response for GetUserConfig"
  content_type = "application/json"

  schema = <<EOF
  {
    "$schema":"http://json-schema.org/draft-04/schema#",
      "title":"UserUserConfig",
      "type":"object",
      "properties":{
        "Role":{"type":"string"},
        "Policy":{"type":"string"},
        "HomeDirectory":{"type":"string"},
        "PublicKeys":{"type":"array","items":{"type":"string"}
        }}}
EOF
}
#
resource "aws_api_gateway_method_response" "Method" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.Method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "UserConfigResponseModel"
  }
  depends_on = [
    aws_api_gateway_model.Method
  ]
}
#
resource "aws_api_gateway_integration_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.Method.http_method
  status_code = aws_api_gateway_method_response.Method.status_code
  depends_on = [
    aws_api_gateway_rest_api.apirest,
    aws_api_gateway_resource.config,
    aws_api_gateway_method.Method,
    aws_api_gateway_method_response.Method,
  ]
}
###################################################
resource "aws_api_gateway_deployment" "apirest" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  depends_on = [
    aws_api_gateway_method.Method,
    aws_api_gateway_method_response.Method,
    aws_api_gateway_integration.get,
    aws_api_gateway_integration_response.get,
  ]
}
#
resource "aws_api_gateway_stage" "apirest" {
  deployment_id = aws_api_gateway_deployment.apirest.id
  rest_api_id   = aws_api_gateway_rest_api.apirest.id
  stage_name    = var.api_gateway_defaults.deployment
}
#
resource "aws_api_gateway_method_settings" "apirest" {
  rest_api_id = aws_api_gateway_rest_api.apirest.id
  stage_name  = aws_api_gateway_stage.apirest.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    throttling_rate_limit  = "10000"
    throttling_burst_limit = "5000"
  }
}
#
##########################
# Allow API Gateway to push logs to CloudWatch
resource "aws_api_gateway_account" "api" {
  cloudwatch_role_arn = aws_iam_role.apigateway.arn
  depends_on = [
    aws_iam_role.apigateway
  ]
}
