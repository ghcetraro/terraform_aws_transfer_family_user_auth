#
# main
variable "customer" {}
variable "environment" {}
variable "region" {}
#
# transfer
variable "transfer_defaults" {
  type = map(string)
}
#
# lambda
variable "lambda_defaults" {
  type = map(string)
}
#
# cloudwatch
variable "cloudwatch_retention" {
  type    = string
  default = 7
}
#
# apigateway
variable "api_gateway_defaults" {
  type = map(string)
}
#
# secret manager 
variable "secret_manager_defaults" {
  type    = map(any)
  default = {}
}
#